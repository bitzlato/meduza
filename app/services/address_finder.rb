# Находит и отдаёт выходящие адреса транзакции
#
class AddressFinder
  # TODO: передавать из какой сети адрес
  def income_addresses_of_transaction(tx, cc_code)
    meth = cc_code.downcase + '_addresses'

    if respond_to? meth, true
      send meth, tx
    else
      raise "Unknown cc_code #{cc_code} (no method #{meth} found)"
    end
  end

  private

  def btc_addresses(tx)
    BitcoinRPC
      .new
      .getrawtransaction(tx, true)
      .fetch('vin')
      .map do |vin_hash|
        BitcoinRPC
          .new
          .getrawtransaction(vin_hash.fetch('txid'), true)
          .fetch('vout')[vin_hash.fetch('vout')]
          .dig('scriptPubKey', 'addresses')
      end
      .flatten
      .uniq
      .freeze
  end
end
