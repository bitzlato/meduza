class AnalysisResult < ApplicationRecord
  has_many :address_analysis

  validates :cc_code, presence: true

  delegate :risk_msg, :transaction_entity_name, to: :response

  def response
    OpenStruct.new(raw_response)
  end
end
