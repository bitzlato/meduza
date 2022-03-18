
module Daemons
  # Legacy
  # Берёт все не обработанные транзакции из P2P blockchain_tx и засовывает в pending_transactions
  class LegacyPender < Base
    @sleep_time = 1.seconds
    LIMIT = 100

    CHECK_START_DATE = Date.parse('01-10-2021')

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      AML_ANALYZABLE_CODES.each do |cc_code|
        Rails.logger.debug("[LegacyPender] Select #{cc_code}")
        btx_count = BlockchainTx
          .receive
          .where('created_at>=?', CHECK_START_DATE)
          .where(meduza_status: nil)
          .where(cc_code: cc_code)
          .order(:id)
          .limit(LIMIT)
          .each do |btx|
          Rails.logger.info("[LegacyPender] Put pending analysis #{btx.id}: #{btx.txid} #{cc_code}")
          payload = {
            txid:    btx.txid,
            cc_code: btx.cc_code,
            source:  'p2p',
            meta: { blockchain_tx_id: btx.id }
          }
          btx.update! meduza_status: { status: :pended }
          AMQP::Queue.publish :meduza, payload,
            correlation_id: btx.id,
            routing_key: AMQP::Config.binding(:transaction_pender).fetch(:routing_key),
            reply_to: AMQP::Config.binding(:legacy_rpc_callback).fetch(:routing_key)
        end.count
        Rails.logger.debug("[LegacyPender] #{btx_count} processed for #{cc_code}")
        break unless @running
      end
    end
  end
end
