class ValegaAnalyzer
  class CheckError < StandardError
    attr_reader :meta
    def initialize(msg, meta)
      @meta = meta
      super(msg)
    end
  end

  def self.pass?(risk_level, risk_confidence)
    risk_level != 3 && risk_confidence != 3
  end

  def analyze(address_transactions, cc_code)
    return [] if address_transactions.empty?
    ValegaClient
      .instance
      .risk_analysis(address_transactions: address_transactions, asset_type_id: ValegaClient.get_asset_type_id(cc_code))
      .map do |response|
        if response.key? 'error'
          AnalysisResult.create!(
            address_transactions: response.fetch('value'),
            raw_response: response,
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
