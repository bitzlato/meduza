class ValegaAnalyzer
  # Делает анализ предоставленных адесов
  # @param addresses Array[String]
  def analyze_addresses(addresses, cc_code)
    addresses.each_slice ValegaClient::MAX_ELEMENTS do |slice|
      ValegaClient
        .instance
        .risk_analysis(address_transactions: slice, asset_type_id: ValegaClient.get_asset_type_id(cc_code))
        .map do |response|
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

  # @param blockchain_txs Array[BlockchainTx]
  def analyze_transaction(blockchain_txs, cc_code)
    blockchain_txs = blockchain_txs.to_a
    ValegaClient
      .instance
      .risk_analysis(address_transactions: blockchain_txs.map(&:txid), asset_type_id: ValegaClient.get_asset_type_id(cc_code))
      .map { |response| perform_response response }
  end

  def perform_response(response)
    txid = response.fetch('value')
    risks = response.slice('risk_level', 'risk_confidence')

    ar = AnalysisResult.create!(
      risks.merge(address_transaction: txid, raw_response: response)
    )

    btx = blockchain_txs.find { |btx| btx.txid == txid }

    attrs = {
      blockchain_tx: btx,
      txid: txid,
      cc_code: cc_code,
      analysis_result: ar,
    }
    ta = TransactionAnalysis
      .create_with(attrs)
      .find_or_create_by!(blockchain_tx_id: btx.id)

    ta.analysis_result = ar
    ta.save! if ta.changed?
  end
end
