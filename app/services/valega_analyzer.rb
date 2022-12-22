class ValegaAnalyzer
  class CheckError < StandardError
    attr_reader :meta
    def initialize(msg, meta)
      @meta = meta
      super(msg)
    end
  end

  ANALYZER_NAME = 'Valega'.freeze

  ADDRESS_DANGER_RISK_LEVEL = 3
  ADDRESS_DANGER_RISK_CONFIDENCE = 1.0

  # Для входящих транзакций
  TRANSACTION_DANGER_RISK_LEVEL = 3
  TRANSACTION_DANGER_RISK_CONFIDENCE = 0.0

  def self.pass?(type, risk_level, risk_confidence)
    !block?(type, risk_level, risk_confidence)
  end

  def self.block?(type, risk_level, risk_confidence)
    if type.to_s == 'address'
      risk_level >= ADDRESS_DANGER_RISK_LEVEL && risk_confidence >= ADDRESS_DANGER_RISK_CONFIDENCE
    elsif type.to_s == 'transaction'
      risk_level >= TRANSACTION_DANGER_RISK_LEVEL && risk_confidence >= TRANSACTION_DANGER_RISK_CONFIDENCE
    else
      raise "Unknown type #{type}"
    end
  end

  def analyze(address_transactions, cc_code)
    return [] if address_transactions.empty?
    ValegaClient
      .instance
      .risk_analysis(address_transactions: address_transactions, asset_type_id: ValegaClient.get_asset_type_id(cc_code))
      .map do |response|
      if response.key? 'error'
        AnalysisResult.create!(
          address_transaction: response.fetch('value'),
          raw_response: response,
          cc_code: cc_code,
          type: 'error'
        )
      else
        risks = response.slice('risk_level', 'risk_confidence')

        AnalysisResult.create! risks.merge(
          address_transaction: response.fetch('value'),
          raw_response: response,
          cc_code: cc_code,
          type: response.fetch('type')
        )
      end
    end
  end
end
