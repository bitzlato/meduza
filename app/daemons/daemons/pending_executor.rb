require "benchmark"

# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

module Daemons
  # Берёт все не обработанные транзакции из pending_transactions и обрабатывает
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class PendingExecutor < Base
    LIMIT = 100
    MAX_RETRY_COUNT = 15 # ~2 дня

    @sleep_time = 2.seconds

    def process
      logger.tagged 'PendingExecutor' do
        if Flipper.enabled?(:scorechain_aml)
          scorechain_process
        else
          valega_process
        end
      end
    end

    def scorechain_process
      logger.tagged 'scorechain_process' do
        logger.info("Start process")
        PendingAnalysis.group(:cc_code).count.keys.each do |cc_code|
          logger.debug("Process #{cc_code}")
          pending_analises = PendingAnalysis
            .pending
            .where(cc_code: cc_code)
            .where.not(cc_code: Currency.paused.pluck(:cc_code))
            .order('type, id') # Нам повезло что address отдается первым, его и надо первым проверять
            .limit(LIMIT)

          # Докидываем на проверку старые транзакции
          unless pending_analises.any?
            logger.debug("No new pending transactions for cc_code=#{cc_code}")
            next
          end
          logger.info("Process pending transactions #{pending_analises.pluck(:address_transaction).join(',')} for #{cc_code}")
          pending_analises_for_scorechain = check_existen(pending_analises)
          currency = Currency.find_or_create_by!(cc_code: cc_code)
          if currency.check?
            if AML_ANALYZABLE_CODES.include? cc_code
              logger.info("Check pending analises in scorechain #{pending_analises_for_scorechain.pluck(:address_transaction).join(',')} for #{cc_code}")
              check_in_scorechain pending_analises_for_scorechain, pending_analises, cc_code
            else
              logger.info("Skip pending analises #{pending_analises_for_scorechain.pluck(:address_transaction).join(',')} for #{cc_code}")
              skip_all pending_analises_for_scorechain
            end
          elsif currency.skip?
            logger.info("Skip ALL")
            skip_all pending_analises_for_scorechain
          end
          break unless @running
        rescue StandardError => err
          logger.error "Retry: #{err.message}"
          report_exception err, true, cc_code: cc_code
          sleep 10
        end
      end
    end

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def valega_process
      logger.tagged 'valega_process' do
        logger.info("Start process")
        PendingAnalysis.group(:cc_code).count.keys.each do |cc_code|
          logger.debug("Process #{cc_code}")
          pending_analises = PendingAnalysis
            .pending
            .where(cc_code: cc_code)
            .where.not(cc_code: Currency.paused.pluck(:cc_code))
            .order('type, id') # Нам повезло что address отдается первым, его и надо первым проверять
            .limit(LIMIT)

          # Докидываем на проверку старые транзакции
          unless pending_analises.any?
            logger.debug("No new pending transactions for cc_code=#{cc_code}")
            next
          end
          logger.info("Process pending transactions #{pending_analises.pluck(:address_transaction).join(',')} for #{cc_code}")
          pending_analises_for_valega = check_existen pending_analises
          currency = Currency.find_or_create_by!(cc_code: cc_code)
          if currency.check?
            if AML_ANALYZABLE_CODES.include? cc_code
              logger.info("Check pending analises in valega #{pending_analises_for_valega.pluck(:address_transaction).join(',')} for #{cc_code}")
              check_in_valega pending_analises_for_valega, pending_analises, cc_code
            else
              logger.info("Skip pending analises #{pending_analises_for_valega.pluck(:address_transaction).join(',')} for #{cc_code}")
              skip_all pending_analises_for_valega
            end
          elsif currency.skip?
            logger.info("Skip ALL")
            skip_all pending_analises_for_valega
          end
          break unless @running
        rescue ValegaClient::TooManyRequests => err
          report_exception err, true
          logger.error "Retry: #{err.message}"
          sleep 10
          retry
        rescue StandardError => e
          report_exception e, true, cc_code: cc_code
          sleep 10
        end
      end
    end

    private

    def skip_all(pending_analises)
      pending_analises.each do |pending_analisis|
        pending_analisis.skip!
        rpc_callback pending_analisis, from: :skip_all if pending_analisis.callback?
      end
    end

    def check_existen(pending_analises)
      pending_analises.reject do |pending_analisis|
        transaction_analysis = TransactionAnalysis.find_by(cc_code: pending_analisis.cc_code, txid: pending_analisis.address_transaction)
        if transaction_analysis.present? && transaction_analysis.analysis_result.present?
          logger.info("Push saved transaction_analysis #{transaction_analysis.as_json}")
          pending_analisis.update! analysis_result: transaction_analysis.analysis_result
          pending_analisis.done!
          rpc_callback pending_analisis, transaction_analysis_id: transaction_analysis.id, from: :check_existen if pending_analisis.callback?
        else
          false
        end
      end
    end

    def check_in_valega(pending_analises_for_valega, pending_analises, cc_code)
      pending_analises_for_valega.each_slice(ValegaClient::MAX_ELEMENTS) do |sliced|
        logger.info "Check in valega #{sliced.join(', ')}"

        analysis_results = nil
        Yabeda.meduza.valega_request_total.increment(cc_code: cc_code)
        time = Benchmark.measure do
          analysis_results = ValegaAnalyzer
            .new
            .analyze(sliced.map(&:address_transaction), cc_code)
        end
        Yabeda.meduza.valega_request_runtime.measure({cc_code: cc_code}, time.total * 1000)

        logger.info "Result count #{analysis_results.count}"
        analysis_results.each do |analysis_result|
          # TODO Выбирать все пендинги с подобной транзакцией и адресом и отмечать их тоже
          #
          logger.info "Process result #{analysis_result.address_transaction}"
          Yabeda.meduza.checked_pending_analyses.increment({type: analysis_result.type, cc_code: cc_code, risk_level: analysis_result.risk_level}, by: 1)
          pending_analisis = pending_analises.find_by cc_code: cc_code, address_transaction: analysis_result.address_transaction
          logger.info "Done result #{analysis_result.address_transaction}"
          if analysis_result.transaction?
            done_transaction_analisis pending_analisis, analysis_result
          elsif analysis_result.address?
            done_address_analisis pending_analisis, analysis_result
          elsif analysis_result.error?
            done_error_analysis pending_analisis, analysis_result
          else
            raise "not supported #{analysis_result}"
          end
        end
      end
    end

    # rubocop:disable Metrics/MethodLength
    def check_in_scorechain(pending_analises_for_scorechain, _pending_analises, cc_code)
      logger.info "Check in scorechain #{pending_analises_for_scorechain.join(', ')}"

      pending_analises_for_scorechain.each do |pending_analise|
        # TODO: Пропускаем проверку если next_try_at больше текущего времени
        next if pending_analise.next_try_at.value && pending_analise.next_try_at.value > Time.current

        # ждем если достигли лимита
        scorechain_rate_limiter.shift

        analysis_result = nil

        Yabeda.meduza.scorechain_request_total.increment(cc_code: cc_code)
        time = Benchmark.measure do
          analysis_result = if pending_analise.address?
                              Scorechain::Analyzer.analize_wallet(wallet: pending_analise.address_transaction, blockchain: pending_analise.blockchain, coin: cc_code)
                            else
                              Scorechain::Analyzer.analize_transaction(txid: pending_analise.address_transaction, blockchain: pending_analise.blockchain, coin: cc_code)
                            end
        end
        Yabeda.meduza.scorechain_request_runtime.measure({cc_code: cc_code}, time.total * 1000)

        logger.info "Process result #{analysis_result.address_transaction}"
        Yabeda.meduza.checked_pending_analyses.increment({type: analysis_result.type, cc_code: cc_code, risk_level: analysis_result.risk_level}, by: 1)
        logger.info "Done result #{analysis_result.address_transaction}"
        if analysis_result.transaction?
          done_transaction_analisis pending_analise, analysis_result
        elsif analysis_result.address?
          done_address_analisis pending_analise, analysis_result
        elsif analysis_result.error?
          done_error_analysis pending_analise, analysis_result
        elsif analysis_result.no_result?
          done_no_result_analysis pending_analise, analysis_result
        else
          raise "not supported #{analysis_result}"
        end
      rescue Scorechain::Analyzer::NotSupportedBlockchain => e
        # TODO: пропускаем если блокчейн не поддерживается
        logger.info "Skipped #{pending_analise.address_transaction}. #{e.message}"
        report_exception e, true, { pending_analise: pending_analise }
        pending_analise.skip!
        rpc_callback pending_analise, from: :check_in_scorechain if pending_analise.callback?
      rescue Scorechain::Analyzer::UnprocessableTransaction => e
        # TODO: Возможно транзакция еще не подтвердилась в сети
        # оставляем pending_analise в pending в надеже что пройдет проверку в следующий раз
        # Переводим в errored если кол-во попыток исчерпано
        retry_count = pending_analise.retry_count.increment
        if retry_count < MAX_RETRY_COUNT
          pending_analise.next_try_at = Time.current + exp_delay(retry_count)
          logger.info "Leave in pending state #{pending_analise}. retry_count=#{retry_count} next_try_at=#{pending_analise.next_try_at}: #{err.message}"
        else
          pending_analise.error!
          logger.info "Transit to error state #{pending_analise}. #{e.message}"
          SlackNotifier.notifications.ping(":warning: [Error] Исчерпано кол-во попыток проверок для https://meduza.lgk.one/pending_analyses/#{pending_analise.id}.")
        end
      rescue ScorechainClient::TooManyRequests => err
        report_exception err, true
        logger.error "Retry: #{err.message}"
        sleep 10
        retry
      rescue ScorechainClient::ResponseError => err
        # TODO: Не блочит проверку остальных адресов/транзакций
        # если проверка упала по причине не правильных данных или др.
        report_exception err, true, { pending_analise: pending_analise }
        logger.error "Retry: #{err.message}"
      end
    end
    # rubocop:enable Metrics/MethodLength

    def done_no_result_analysis(pending_analisis, analysis_result)
      pending_analisis.update! analysis_result: analysis_result
      pending_analisis.skip!
      rpc_callback pending_analisis, from: :done_no_result_analysis if pending_analisis.callback?
    end

    def done_error_analysis(pending_analisis, analysis_result)
      pending_analisis.update! analysis_result: analysis_result
      pending_analisis.done!
      rpc_callback pending_analisis, from: :done_error_analisis if pending_analisis.callback?
    end

    def done_address_analisis(pending_analisis, analysis_result)
      address_analysis = AddressAnalysis
        .create_with(analysis_result: analysis_result, risk_level: analysis_result.risk_level, risk_confidence: analysis_result.risk_confidence)
        .find_or_create_by!(
          address: analysis_result.address_transaction,
          cc_code: pending_analisis.cc_code
      )
      address_analysis.update! analysis_result: analysis_result unless address_analysis.analysis_result == analysis_result
      pending_analisis.update! analysis_result: analysis_result
      pending_analisis.done!
      rpc_callback pending_analisis, address_analysis_id: address_analysis.id, from: :done_address_analisis if pending_analisis.callback?
    rescue ActiveRecord::RecordNotUnique => e
      logger.error "done_address_analisis #{pending_analisis.id} -> #{e}"
      report_exception e, true, { pending_analisis: pending_analisis, analysis_result: analysis_result }
      retry if e.record.is_a? AddressAnalysis
    end

    def done_transaction_analisis(pending_analisis, analysis_result)
      transaction_analysis = TransactionAnalysis
        .create_with(analysis_result: analysis_result, risk_level: analysis_result.risk_level, risk_confidence: analysis_result.risk_confidence)
        .find_or_create_by!(
          txid: analysis_result.address_transaction,
          cc_code: pending_analisis.cc_code
      )
      transaction_analysis.update! analysis_result: analysis_result unless transaction_analysis.analysis_result == analysis_result
      pending_analisis.update! analysis_result: analysis_result
      pending_analisis.done!
      rpc_callback pending_analisis, transaction_analysis_id: transaction_analysis.id, from: :done_transaction_analisis if pending_analisis.callback?

      # TODO analysis_result.address? создавать AddressAnalysis
    rescue ActiveRecord::RecordNotUnique => e
      logger.error "done_transaction_analisis #{pending_analisis.id} -> #{e}"
      report_exception e, true, { pending_analisis: pending_analisis, analysis_result: analysis_result }
      retry if e.record.is_a? TransactionAnalysis
    end

    def rpc_callback(pending_analisis, extra = {})
      if pending_analisis.done?
        analysis_result = pending_analisis.analysis_result
        action = analysis_result.pass? ? :pass : :block
      elsif pending_analisis.skipped?
        action = :pass
      else
        report_exception 'Do nothing', true, pending_analisis: pending_analisis.as_json
        return
      end

      payload = {
        address_transaction: pending_analisis.address_transaction,
        cc_code: pending_analisis.cc_code,
        action: action,
        analysis_result_id: analysis_result.try(:id),
        pending_analisis_state: pending_analisis.state
      }.merge extra
      properties = { correlation_id: pending_analisis.correlation_id, routing_key: pending_analisis.reply_to }
      logger.info "rpc_callback with payload #{payload} and properties #{properties}"
      AMQP::Queue.publish :meduza, payload, properties
      pending_analisis.touch :replied_at
    end

    # Экспоненциальный delay
    # https://gist.github.com/marcotc/39b0d5e8100f0f4cd4d38eff9f09dcd5
    def exp_delay(retry_count)
      (retry_count**4) + 15 + (rand(30) * (retry_count + 1))
    end

    def scorechain_rate_limiter
      @scorechain_rate_limiter ||= Limiter::RateQueue.new(50, interval: 10) do
        logger.info "Hit the limit, waiting"
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
