class AddressesChecker
  # Делает анализ предоставленных адесов
  # @param addresses Array[String]
  def do_analysis(addresses)
    ValegaClient.new.risk_analysis(address_transactions: addresses).each do |response|
      address = response.fetch('value')
      risks = response.slice('risk_level', 'risk_confidence')

      ar = AnalysisResult.create!(
        risks
        .merge(
          address: address,
          raw_response: response
        )
      )

      AddressAnalysis.upsert(risks.merge(address: address, analysis_result: ar, updated_at: Time.zone.now))
    end
  end
end
