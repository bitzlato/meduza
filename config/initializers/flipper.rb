require 'flipper/adapters/active_record'
Flipper.configure do |config|
  config.adapter { Flipper::Adapters::ActiveRecord.new }
end

VALEGA_CURL_LOGGER = :valega_curl_logger
Flipper.add VALEGA_CURL_LOGGER
