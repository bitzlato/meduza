require 'flipper/adapters/active_record'

Flipper.configure do |config|
  config.adapter { Flipper::Adapters::ActiveRecord.new }
end

FREEZE_ON_BAD_TRANSACTON = :freeze_on_bad_transaction
VALEGA_CURL_LOGGER = :valega_curl_logger
