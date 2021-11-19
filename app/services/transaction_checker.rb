# Вытаскивает по указанной транзакции все входящие адреса и проверяет из в valega
#
class TransactionChecker
  def check!(txid, cc_code)
    addresses = AddressFinder
                .new
                .income_addresses_of_transaction(txid, cc_code)
                .reject { |address| AddressAnalysis.actual?(address) }

    Rails.logger.info("Found addresses #{addresses.join(',')} for #{cc_code}")
    AddressesChecker.new.do_analysis(addresses) if addresses.any?
  end
end
