class ValegaAnalyzer
  # Делает анализ предоставленных адесов
  # @param addresses Array[String]
  def analyze_addresses(addresses)
    addresses.each_slice ValegaClient::MAX_ELEMENTS do |slice|
      ValegaClient.
        new.
        risk_analysis(address_transactions: slice, asset_type_id: ValetaClient.get_asset_type_id(cc_code)).
        map do |response|

        address = response.fetch('value')
        risks = response.slice('risk_level', 'risk_confidence')

        ar = AnalysisResult.create!(
          risks
          .merge(
            address_transaction: address,
            raw_response: response
          )
        )

        AddressAnalysis.upsert!(risks.merge(address: address, analysis_result: ar, updated_at: Time.zone.now))
      end
    end
  end

  def analyze_transcation(txid, cc_code)
    ValegaClient.
      new.
      risk_analysis(address_transactions: txid, asset_type_id: ValegaClient.get_asset_type_id(cc_code)).
      map do |response|

      raise 'value does not equal to txid' unless txid == response.fetch('value')
      risks = response.slice('risk_level', 'risk_confidence')

      ar = AnalysisResult.create!(
        risks
        .merge(
          address_transaction: txid,
          raw_response: response
        )
      )

      TransactionAnalysis.upsert!(risks.merge(txid: txid, cc_code: cc_code, analysis_result: ar, updated_at: Time.zone.now))
    end
  end
end
