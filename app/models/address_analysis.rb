class AddressAnalysis < ApplicationRecord
  belongs_to :analysis_result

  upsert_keys %i[address]

  def self.actual?(address)
    aa = find_by(address: address)
    return false if aa.nil?
    aa.updated_at > 1.week.ago
  end
end
