class AnalysisResult < ApplicationRecord
  self.inheritance_column = nil

  alias_attribute :txid, :address_transaction

  validates :cc_code, presence: true, unless: :error?

  TYPES = %w[address transaction error]
  validates :type, presence: true, inclusion: { in: TYPES }

  delegate :entity_name, :entity_dir_name, :risk_msg, :report_url, :observations, to: :response, allow_nil: true

  def self.csv_attributes
    attribute_names + %w[entity_name entity_dir_name risk_msg report_url observations]
  end

  def pass?
    return false if type == 'error'
    if analyzer == Scorechain::Analyzer::ANALYZER_NAME
      Scorechain::Analyzer.pass?(self)
    else
      ValegaAnalyzer.pass? type, risk_level, risk_confidence
    end
  end

  def error?
    type == 'error'
  end

  def response
    @response ||= if analyzer == Scorechain::Analyzer::ANALYZER_NAME
                    AnalisisResponse::Scorechain.new(raw_response)
                  else
                    AnalisisResponse::Valega.new(raw_response)
                  end
  end

  def transaction?
    type == 'transaction'
  end

  def address?
    type == 'address'
  end

  def message
    if error?
      response.error || 'no error message'
    else
      [risk_msg.presence, entity_name.presence].compact.join('; ') || 'no message'
    end
  end

  def to_s
    [cc_code, address_transaction, 'risk_level:' + risk_level.to_s, 'risk_confidence:' + risk_confidence.to_s, risk_msg, entity_name].join('; ')
  end
end
