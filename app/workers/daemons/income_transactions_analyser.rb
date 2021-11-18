module Workers
  module Daemons
    class IncomeTransactionsAnalyser < Base
      SLEEP_INTERVAL = 10 # seconds
      def process(service)
        ValegaService.new.do_analysis(addresses)
        sleep SLEEP_INTERVAL
      end
    end
  end
end
