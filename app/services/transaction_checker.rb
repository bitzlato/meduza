# Вытаскивает по указанной транзакции все входящие адреса и проверяет из в valega
#
class TransactionChecker
  def check!(txid, cc_code)
    addresses = AddressFinder
                .new
                .income_addresses_of_transaction(txid, cc_code)

    Rails.logger.info("Found addresses #{addresses.join(',')} for #{cc_code}")

    addresses_to_analyse = addresses.reject { |address| AddressAnalysis.actual?(address) }
    AddressesChecker.new.do_analysis(addresses_to_analyse) if addresses_to_analyse.any?
    TransactionAnalysis.upsert!(
      txid: txid,
      cc_code: cc_code,
      input_addresses: addresses,
      min_risk_level: AddressAnalysis.where(address: addresses).minimum(:risk_level)
    )
  end
end
