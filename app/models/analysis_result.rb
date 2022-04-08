class AnalysisResult < ApplicationRecord
  self.inheritance_column = nil

  alias_attribute :txid, :address_transaction

  has_many :address_analysis

  validates :cc_code, presence: true

  TYPES = %w[address transaction]
  validates :type, presence: true, inclusion: { in: TYPES }

  delegate :risk_msg, :transaction_entity_name, to: :response

  def pass?(analysis_result)
    ValegaAnalyzer.pass? risk_level, risk_confidence
  end

  def response
    OpenStruct.new(raw_response)
  end

  def transaction?
    type == 'transaction'
  end

  def address?
    type == 'address'
  end

  def to_s
    [cc_code, address_transaction, 'risk_level:' + risk_level.to_s, 'risk_confidence:' + risk_confidence.to_s, risk_msg, transaction_entity_name].join('; ')
  end
end
