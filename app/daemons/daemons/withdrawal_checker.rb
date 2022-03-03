require 'sys_jwt'

module Daemons
  class WithdrawalChecker < Base
    @sleep_time = 2.seconds

    def process
      logger.tagged('WithdrawChecker') do
        Withdrawal.aml.find_each do |withdrawal|
          if AddressVerifier.new(withdrawal.address, withdrawal.cc_code).pass?
            withdrawal.pending!
          else
            freeze_user!(withdrawal)
          end
        end
      end
    end

    private

    def freeze_user!(withdrawal)
      params = {
        reason: "Грязный вывод ##{withdrawal.id}",
        expire: 4801477368000,
        type: 'all',
        unfreeze: false
      }

      response = adm_connection.post "admin/p2p/freeze/#{withdrawal.user_id}/", JSON.generate(params)

      raise "Wrong response status (#{response.status}) with body #{response.body}" unless response.success?
    end

    def adm_connection
      bearer = AdmJWT.new.encode

      connection = Faraday.new url: ENV.fetch('BITZLATO_API_URL') do |c|
        c.use Faraday::Response::Logger
        c.headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
        c.request :curl, Rails.logger, :debug if ENV['BITZLATO_CURL_LOGGER']
        c.authorization :Bearer, bearer
      end
    end
  end
end
