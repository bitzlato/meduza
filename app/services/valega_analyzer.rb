class ValegaAnalyzer
  class CheckError < StandardError
    attr_reader :meta
    def initialize(msg, meta)
      @meta = meta
      super(msg)
    end
  end

  def self.pass?(risk_level)
    risk_level == 1
  end

  def analyze(address_transactions, cc_code)
    return [] if address_transactions.empty?
    ValegaClient
      .instance
      .risk_analysis(address_transactions: address_transactions, asset_type_id: ValegaClient.get_asset_type_id(cc_code))
      .map do |response|
        # {"result":true,"data":[{"value":"00","error":"Please analyse BTC address. Please try again!"}]}
        raise CheckError.new, response.fetch('error'), response if response.key? 'error'
        risks = response.slice('risk_level', 'risk_confidence')

        AnalysisResult.create! risks.merge(address_transaction: response.fetch('value'), cc_code: cc_code, raw_response: response, type: response.fetch('type'))
      rescue CheckError => err
        report_exception err, true, err.meta
    end
  end
end
