class TransactionAnalysis < ApplicationRecord
  belongs_to :analysis_result, optional: true

  upsert_keys [:txid]

  validates :input_addresses, presence: true, unless: :analysis_result

  def self.actual?(txid)
    ta = find_by(txid: txid)
    return false if ta.nil?

    ta.updated_at > 1.week.ago
  end
end
