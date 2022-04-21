require 'flipper/adapters/active_record'
Flipper.configure do |config|
  config.adapter { Flipper::Adapters::ActiveRecord.new }
end

VALEGA_CURL_LOGGER = :valega_curl_logger
Flipper.add VALEGA_CURL_LOGGER

FREEZE_ON_BAD_TRANSACTON = :freeze_on_bad_transaction
Flipper.add FREEZE_ON_BAD_TRANSACTON
