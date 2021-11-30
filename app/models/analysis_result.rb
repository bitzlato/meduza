class AnalysisResult < ApplicationRecord
  has_many :address_analysis

  validates :cc_code, presence: true
end
