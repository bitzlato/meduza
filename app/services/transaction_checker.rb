# Вытаскивает по указанной транзакции все входящие адреса и проверяет из в valega
#
class TransactionChecker
  def check!(txid, cc_code)
    Rails.logger.info("Check transcation #{txid} (#{cc_code})")

    return ValegaAnalyzer.new.analyze_transaction(txid, cc_code) unless AddressFinder.support_codes.include? cc_code

    return ValegaAnalyzer.new.analyze_transaction(txid, cc_code) unless ENV.true?('ANALYZE_ADDRESSES')

    addresses = AddressFinder
      .new
      .income_addresses_of_transaction(txid, cc_code)
      .presence

    if addresses.any?
      Rails.logger.info("Found addresses #{addresses.join(',')} for #{cc_code}")
      addresses_to_analyze = addresses.reject { |address| AddressAnalysis.actual?(address) }.compact
      ValegaAnalyzer.new.analyze_addresses(addresses_to_analyze, cc_code) if addresses_to_analyze.any?
    end

    ValegaAnalyzer.new.analyze_transaction(txid, cc_code)

    # Узнаем на основе данных с valega
    # upsert_transaction_with_addresses addresses
  end

  private

  def upsert_transaction_with_addresses(addresses)
    risk_level = AddressAnalysis.where(address: addresses).maximum(:risk_level)
    risk_confidence = AddressAnalysis.where(address: addresses).minimum(:risk_confidence)

    TransactionAnalysis.upsert!(
      txid: txid,
      cc_code: cc_code,
      input_addresses: addresses.presence,
      risk_level: risk_level,
      risk_confidence: risk_confidence
    )
  end
end
