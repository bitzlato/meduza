class AddressAnalysis < ApplicationRecord
  # "risk_level": 1, — Safe;
  # "risk_level": 2, — Suspicious;
  # "risk_level": 3, — Dangerous.

  belongs_to :analysis_result

  upsert_keys %i[address]

  def self.actual?(address)
    aa = find_by(address: address)
    return false if aa.nil?
    aa.updated_at > 1.week.ago
  end
end
