# frozen_string_literal: true

require File.join(ENV.fetch('RAILS_ROOT'), 'config', 'environment')

raise "Daemon name must be provided." if ARGV.size.zero?

name = ARGV[0]
worker = "Daemons::#{name.camelize}".constantize.new

terminate = proc do
  puts "Terminating worker .."
  worker.stop
  puts "Stopped."
end

Signal.trap("INT",  &terminate)
Signal.trap("TERM", &terminate)

begin
  worker.run
rescue StandardError => e
  if is_db_connection_error?(e)
    Rails.logger.error(db: :unhealthy, message: e.message)
    raise e
  end

  report_exception(e)
end
