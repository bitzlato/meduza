class ValegaAnalyzer
  class CheckError < StandardError
    attr_reader :meta
    def initialize(msg, meta)
      @meta = meta
      super(msg)
    end
  end
  # Делает анализ предоставленных адесов
  # @param addresses Array[String]
  def analyze_addresses(addresses, cc_code)
    addresses.each_slice ValegaClient::MAX_ELEMENTS do |slice|
      ValegaClient
        .instance
        .risk_analysis(address_transactions: slice, asset_type_id: ValegaClient.get_asset_type_id(cc_code))
        .map do |response|

        # {"result":true,"data":[{"value":"00","error":"Please analyse BTC address. Please try again!"}]}
        address = response.fetch('value')
        raise CheckError.new, response.fetch('error'), response if response.key? 'error'
        risks = response.slice('risk_level', 'risk_confidence')

        ar = AnalysisResult.create!(
          risks
          .merge(
            address_transaction: address,
            raw_response: response
        )
        )

        AddressAnalysis.upsert!(risks.merge(address: address, analysis_result: ar, updated_at: Time.zone.now))
      rescue CheckError => err
        report_exception err, true, err.meta
      end
    end
  end

  # @param blockchain_txs Array[BlockchainTx]
  def analyze_transaction(address_transactions, cc_code)
    ValegaClient
      .instance
      .risk_analysis(address_transactions: address_transactions, asset_type_id: ValegaClient.get_asset_type_id(cc_code))
      .map { |response| perform_response response, cc_code }
  end

  def perform_response(response, cc_code)
    txid = response.fetch('value')
    risks = response.slice('risk_level', 'risk_confidence')

    AnalysisResult.create!(
      risks.merge(address_transaction: txid, cc_code: cc_code, raw_response: response)
    )
  end
end
