# Вытаскивает по указанной транзакции все входящие адреса и проверяет из в valega
#
class TransactionChecker
  def check!(txid)
    addresses = AddressFinder
      .new
      .income_addresses_of_transaction(txid)
      .reject { |address| AddressAnalysis.actual?(address) }

    Rails.logger.info("Found addresses #{addresses.join(',')}")
    AddressesChecker.new.do_analysis(addresses) if addresses.any?
  end
end
