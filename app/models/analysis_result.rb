class AnalysisResult < ApplicationRecord
  alias_attribute :txid, :address_transaction

  has_many :address_analysis

  validates :cc_code, presence: true

  delegate :risk_msg, :transaction_entity_name, to: :response

  def response
    OpenStruct.new(raw_response)
  end

  def to_s
    [cc_code, address_transaction, 'risk_level:' + risk_level.to_s, 'risk_confidence:' + risk_confidence.to_s, risk_msg, transaction_entity_name].join('; ')
  end
end
