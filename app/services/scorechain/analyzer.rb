# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module Scorechain
  module Analyzer
    module_function

    Error = Class.new(StandardError)
    NotSupportedBlockchain = Class.new(Error)
    UnprocessableTransaction = Class.new(Error)

    ANALYZER_NAME = 'Scorechain'

    ANALYSIS_TYPES = [
      ASSIGNED = 'ASSIGNED',
      INCOMING = 'INCOMING',
      OUTGOING = 'OUTGOING',
      FULL = 'FULL'
    ].freeze

    OBJECT_TYPES = [
      TRANSACTION = 'TRANSACTION',
      ADDRESS = 'ADDRESS',
      WALLET = 'WALLET'
    ].freeze

    BLOCKCHAINS = [
      BITCOIN = 'BITCOIN',
      BITCOINCASH = 'BITCOINCASH',
      LITECOIN = 'LITECOIN',
      DASH = 'DASH',
      ETHEREUM = 'ETHEREUM',
      RIPPLE = 'RIPPLE',
      TEZOS = 'TEZOS',
      TRON = 'TRON',
      BSC = 'BSC'
    ].freeze

    USDT_COIN_CHAIN_IDS = {
      ETHEREUM => '0xdac17f958d2ee523a2206206994597c13d831ec7',
      TRON => 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t'
    }.freeze

    USDT_COIN = 'USDT'
    MAIN_COIN = 'MAIN'

    RISK_LEVEL = {
      'CRITICAL_RISK' => 3,
      'HIGH_RISK' => 2,
      'MEDIUM_RISK' => 2,
      'LOW_RISK' => 1,
      'NO_RISK' => 1
    }.freeze

    DANGER_RISK_LEVEL = RISK_LEVEL['CRITICAL_RISK']

    def pass?(analysis_result)
      !block?(analysis_result)
    end

    def block?(analysis_result)
      analysis_result.risk_level >= DANGER_RISK_LEVEL
    end

    def analize_wallet(wallet:, coin:, blockchain:, analysis_type: ASSIGNED)
      analize(analysis_type: analysis_type, object_type: WALLET, object_id: wallet, coin: coin, blockchain: blockchain, analysis_result_type: :address)
    end

    def analize_transaction(txid:, coin:, blockchain:, analysis_type: INCOMING)
      # TODO: Проверяем что транзакция может быть обработана
      begin
        Scorechain.client.blockchain_transaction(blockchain: blockchain, txid: txid)
      rescue ScorechainClient::InternalServerError => e
        Scorechain.logger.info { "Transaction #{txid} in blockchain #{blockchain} is unprocessable" }
        raise UnprocessableTransaction, e.message
      end

      analize(analysis_type: analysis_type, object_type: TRANSACTION, object_id: txid, coin: coin, blockchain: blockchain, analysis_result_type: :transaction, depth: 1)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/ParameterLists
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/CyclomaticComplexity:
    def analize(analysis_type:, object_type:, object_id:, coin:, analysis_result_type:, blockchain:, depth: nil)
      raise NotSupportedBlockchain, "Blockchain #{blockchain} is not supported" unless BLOCKCHAINS.include?(blockchain)

      scorechain_coin = coin
      # TODO: Для USDT ищем id контракта по названию blockchain,
      # Если не находим, то анализируем по главной монете(MAIN)
      scorechain_coin = USDT_COIN_CHAIN_IDS[blockchain] || MAIN_COIN if scorechain_coin == USDT_COIN

      scorechain_object_id = if object_type == TRANSACTION
                               # TODO: Из беломора может приходить транзакция вида txid:internals:1
                               object_id.split(":").first
                             else
                               # TODO: Удаляем префикс из адреса для сети bitcoincash
                               object_id.delete_prefix("#{BITCOINCASH.downcase}:")
                             end

      params = {
        analysis_type: analysis_type,
        object_type: object_type,
        object_id: scorechain_object_id,
        blockchain: blockchain,
        coin: scorechain_coin,
        depth: depth
      }

      Scorechain.logger.info { "Start analysis: #{params} coin=#{coin}" }

      analysis_result = AnalysisResult.new(
        analyzer: ANALYZER_NAME,
        address_transaction: object_id,
        cc_code: coin,
        blockchain: blockchain,
        type: analysis_result_type
      )

      response = JSON.parse(Scorechain.client.scoring_analysis(**params).body)
    rescue ScorechainClient::NotFound => e
      Scorechain.logger.info { "Analysis not found for #{object_type}=#{object_id}: #{e.message}" }
      analysis_result.update!(type: 'no_result', raw_response: JSON.parse(e.message))
      analysis_result
    rescue ScorechainClient::UnprocessableEntity => e
      Scorechain.logger.info { "Can't process #{object_type}=#{object_id}: #{e.message}" }
      report_exception e, true, params: params.merge(cc_code: coin)
      analysis_result.update!(type: 'error', raw_response: JSON.parse(e.message))
      analysis_result
    else
      analysis = if analysis_type == FULL
                   # Если полный анализ то ищем результат с минимальным score(т.е. c максимальным риском)
                   ANALYSIS_TYPES.map { |at| response.dig('analysis', at.downcase) }
                                 .select { |a| a['hasResult'] }
                                 .min { |a, b| a['result']['score'] <=> b['result']['score'] }
                 else
                   response.dig('analysis', analysis_type.downcase)
                 end

      if analysis && analysis['hasResult']
        result = analysis['result']

        analysis_result.update!(
          raw_response: response,
          risk_level: RISK_LEVEL[result['severity']],
          # score - это risk_level в процентах,
          # тогда risk_confidence обратная величина
          # Например:
          # score(risk_level) = 0.75, тогда risk_confidence = 0.25,
          # score + risk_confidence == 1
          risk_confidence: (100 - result['score']) / 100.0
        )
      else
        analysis_result.update!(type: 'no_result', raw_response: response)
      end
      analysis_result
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/ParameterLists
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity:
  end
end

# rubocop:enable Metrics/ModuleLength
