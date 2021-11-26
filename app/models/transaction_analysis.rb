class TransactionAnalysis < ApplicationRecord
  belongs_to :analysis_result, optional: true
  belongs_to :blockchain_tx

  upsert_keys [:txid]

  scope :include_address, -> (address) { where("input_addresses::jsonb ? :address", address: address) }

  # TODO seach by input_address

  validates :input_addresses, presence: true, unless: :analysis_result

  def self.actual?(txid)
    ta = find_by(txid: txid)
    return false if ta.nil?

    ta.updated_at > 1.week.ago
  end
end
