require 'adm_jwt'

module Daemons
  class WithdrawalChecker < Base
    @sleep_time = 2.seconds

    def process
      logger.tagged('WithdrawChecker') do
        Withdrawal.aml.find_each do |withdrawal|
          logger.tagged("Withdrawal(#{withdrawal.id}) to address #{withdrawal.address}") do
            if AddressVerifier.new(withdrawal.address, withdrawal.cc_code).pass?
              logger.info { 'Has been passed' }
              withdrawal.pending!
            else
              logger.info { 'Has not been passed' }
              freeze_user!(withdrawal)
            end
          end
        end
      end
    end

    private

    def freeze_user!(withdrawal)
      params = {
        reason: "Грязный вывод ##{withdrawal.id} на адрес #{withdrawal.address}",
        expire: 1.year.from_now.to_i,
        type: 'all',
        unfreeze: false
      }

      response = adm_connection.post "admin/p2p/freeze/#{withdrawal.user_id}/", JSON.generate(params)

      if response.success?
        logger.info { "User ##{withdrawal.user_id} has been freezed" }
      else
        logger.info { "User ##{withdrawal.user_id} has not been freezed because P2P is not available" }
        raise "Wrong response status (#{response.status}) with body #{response.body}" unless response.success?
      end
    end

    def adm_connection
      Faraday.new url: ENV.fetch('BITZLATO_API_URL') do |c|
        c.use Faraday::Response::Logger
        c.headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        }
        c.request :curl, Rails.logger, :debug if ENV['BITZLATO_CURL_LOGGER']
        c.request :authorization, 'Bearer', -> { AdmJWT.new.encode }
      end
    end
  end
end
