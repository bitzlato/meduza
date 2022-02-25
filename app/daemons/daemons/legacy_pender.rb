
module Daemons
  # Legacy
  # Берёт все не обработанные транзакции из P2P blockchain_tx и засовывает в pending_transactions
  class LegacyPender < Base
    @sleep_time = 1.seconds

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      Rails.logger.info("[LegacyPender] Start process with #{ANALYZABLE_CODES.to_a.join(',')} analyzable codes")
      count = ANALYZABLE_CODES.each do |cc_code|
        transaction_source = TransactionSource.find_or_create_by!(cc_code: cc_code)
        transaction_source.reload
        self.class.scope
          .where('id > ?', transaction_source.last_processed_blockchain_tx_id)
          .where(cc_code: cc_code)
          .order(:id)
          .limit(ValegaClient::MAX_ELEMENTS)
          .each do |btx|
          Rails.logger.info("Put to penging_transaction #{btx.id}: #{btx.txid} #{cc_code}")
          TransactionAnalysis.create!(txid: btx.txid, cc_code: btx.cc_code, source: 'p2p') unless btx.transaction_analyses.present?
          transaction_source.update! last_processed_blockchain_tx_id: btx.id if btx.id > transaction_source.last_processed_blockchain_tx_id
        end.count
        Rails.logger.info("[LegacyPender] #{count} processed")
        break unless @running
      end
    end

    private

    def self.scope
      BlockchainTx
        .receive
        .where(cc_code: ANALYZABLE_CODES.to_a)
    end
  end
end
