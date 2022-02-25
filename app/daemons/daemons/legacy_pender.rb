
module Daemons
  # Legacy
  # Берёт все не обработанные транзакции из P2P blockchain_tx и засовывает в pending_transactions
  class LegacyPender < Base
    @sleep_time = 1.seconds

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      Rails.logger.info("Start process with #{ANALYZABLE_CODES.to_a.join(',')} analyzable codes")
      ANALYZABLE_CODES.each do |cc_code|
        transaction_source = TransactionSource.find_or_create_by!(cc_code: cc_code)
        transaction_source.reload
        self.class.scope
          .where('id > ?', transaction_source.last_processed_blockchain_tx_id)
          .where(cc_code: cc_code)
          .order(:id)
          .find_each do |btx|
          Rails.logger.info("Put to penging_transaction #{btx.id}: #{btx.txid} #{cc_code}")
          TransactionAnalysis.create!(txid: btx.txid, cc_code: btx.cc_code) unless btx.transaction_analyses.present?
          transaction_source.update! last_processed_blockchain_tx_id: btx.id if btz.id > transaction_source.last_processed_blockchain_tx_id
        end
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