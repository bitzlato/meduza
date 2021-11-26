class ValegaAnalyzer
  # Делает анализ предоставленных адесов
  # @param addresses Array[String]
  def analyze_addresses(addresses, cc_code)
    addresses.each_slice ValegaClient::MAX_ELEMENTS do |slice|
      ValegaClient.
        instance.
        risk_analysis(address_transactions: slice, asset_type_id: ValegaClient.get_asset_type_id(cc_code)).
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

  # @param btx (BlockchainTx)
  def analyze_transaction(btx)
    txid, cc_code = btx.txid, btx.cc_code

    ValegaClient.
      instance.
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

      TransactionAnalysis.
        upsert!(risks.merge(blockchain_tx_id: btx.id, txid: txid, cc_code: cc_code, analysis_result: ar, updated_at: Time.zone.now))
    end
  end
end
