class TransactionSourceDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    object_class.attribute_names.map(&:to_sym) + %i[real_blockchain_tx_id]
  end

  def real_blockchain_tx_id
    BlockchainTx.where(cc_code: cc_code).maximum(:id)
  end
end
