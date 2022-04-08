class AddressAnalysis < ApplicationRecord
  ACTUAL_PERIOD = 1.week

  belongs_to :analysis_result

  validates :cc_code, presence: true
  validates :address, uniqueness: { scope: :cc_code }, presence: true

  upsert_keys [:address, :cc_code]

  def self.actual?(address)
    find_by(address: address).try &:actual?
  end

  def actual?
    pdated_at > ACTUAL_PERIOD.ago
  end
end
