class TransactionAnalysis < ApplicationRecord
  belongs_to :analysis_result

  upsert_keys [:txid]

  def self.actual?(txid)
    ta = find_by(txid: txid)
    return false if ta.nil?

    ta.updated_at > 1.week.ago
  end
end
