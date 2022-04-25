module AMQP
  class LegacyRpcCallback < Base
    #payload = {
    #address_transaction: pending_analisis.address_transaction,
    #cc_code: pending_analisis.cc_code,
    #action: action,
    #analysis_result_id: analysis_result.try(:id),
    #pending_analisis_state: pending_analisis.state
    #}
    #payload.merge! transaction_analysis_id: transaction_analysis.id if transaction_analysis.present?
    def process(payload, metadata)
      logger.info "payload=#{payload}, metadata=#{metadata}"
      payload = payload.symbolize_keys
      ta_id = payload.dig(:transaction_analysis_id)
      if ta_id.present?
        transaction_analysis = TransactionAnalysis.find ta_id
        logger.info "update_blockchain_tx_status for ta_id #{ta_id} #{transaction_analysis.txid}"
        transaction_analysis.update_blockchain_tx_status
      end

      btx = BlockchainTx.find metadata.correlation_id
      action = payload.fetch(:action)
      unless action == 'pass'
        logger.info("Block btx #{btx.id}")
        if btx.deposit_user.present?
          freeze_user! btx, btx.deposit_user, payload.dig(:analysis_result_id) if Flipper.enabled? FREEZE_ON_BAD_TRANSACTON
        elsif btx.withdraw_user.present?
          report_exception StandardError.new('Невалидная транзакция с списывающим пользователем'), true, { blockchain_tx_id: btx.id }
        else
          report_exception StandardError.new('Нет пользователя у транзакции'), true, { blockchain_tx_id: btx.id }
        end
      end
    end

    private

    def freeze_user!(btx, user, analysis_result_id)
      logger.info("Freeze_user #{user.id} txid=#{btx.txid} analysis_result_id=#{analysis_result_id}")

      if btx.meduza_status.dig('freezed_at')
        logger.info('Skip freezing, btx already freezed')
        return
      end

      params = {
        expire: WithdrawalRpcCallback::FREEZE_EXPIRE.from_now.to_i,
        reason: "Грязная входная транзакция ##{btx.txid}, результат анализа #{analysis_result_id}",
        type: 'all',
        unfreeze: false
      }
      response = BitzlatoAPI.new.freeze_user(user.id, params)

      if response.success?
        logger.info { "User ##{user.id} has been freezed" }
      else
        logger.info { "User ##{user.id} has not been freezed" }
        raise "Wrong response status (#{response.status}) with body #{response.body}"
      end
      btx.with_lock do
        btx.update_columns btx.meduza_status.merge(freezed_at: Time.zone.now.iso8601)
      end
    end
  end
end
