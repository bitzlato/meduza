class ValegaService
  # Делает анализ предоставленных адесов
  # @param addresses Array[String]
  def do_analysis(addresses)
    ValegaClient.new.risk_analysis(address_transactions: addresses).each do |response|
      AnalysisResult.create!(
        response.
        slice('risk_level', 'risk_confidence').
        merge(
          address: response.fetch('value'),
          raw_response: response,
        )
      )
    end
  end
end
