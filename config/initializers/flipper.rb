require 'flipper/adapters/active_record'
Flipper.configure do |config|
  config.adapter { Flipper::Adapters::ActiveRecord.new }
end

FEATURE_AML_CHECK=:aml_check
Flipper.add FEATURE_AML_CHECK

VALEGA_CURL_LOGGER = :valega_curl_logger
Flipper.add VALEGA_CURL_LOGGER
