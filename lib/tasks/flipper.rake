namespace :flipper do
  desc 'Add flipper'
  task add: :environment do
    Flipper.add FREEZE_ON_BAD_TRANSACTON
    Flipper.add VALEGA_CURL_LOGGER
  end
end
