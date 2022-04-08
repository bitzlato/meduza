class AnalysisResult < ApplicationRecord
  self.inheritance_column = nil

  alias_attribute :txid, :address_transaction

  has_many :address_analysis

  validates :cc_code, presence: true

  TYPES = %w[address transaction]
  validates :type, presence: true, inclusion: { in: TYPES }

  delegate :risk_msg, :report_url, :observations, to: :response

  def pass?
    ValegaAnalyzer.pass? risk_level, risk_confidence
  end

  def entity_name
    response.address_entity_name || response.transaction_entity_name
  end

  def entity_dir_name
    response.address_entity_dir_name || response.transaction_entity_dir_name
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

  def message
    [risk_msg.presence, entity_name.presence].compact.join('; ') || 'no message'
  end

  def to_s
    [cc_code, address_transaction, 'risk_level:' + risk_level.to_s, 'risk_confidence:' + risk_confidence.to_s, risk_msg, entity_name].join('; ')
  end
end
