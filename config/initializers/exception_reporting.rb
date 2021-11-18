
def catch_and_report_exception(options = {})
  yield
  nil
rescue options.fetch(:class) { StandardError } => e
  report_exception(e)
  e
end

def report_api_error(exception, request)
  message = exception.is_a?(String) ? exception : exception.message
  Rails.logger.info message: message, path: request.path, params: request.params
end

def report_exception(exception, report_to_ets = true, meta = {})
  report_exception_to_screen(exception)
  report_exception_to_ets(exception, meta) if report_to_ets
end

def report_exception_to_screen(exception)
  Rails.logger.error(exception.inspect)
  Rails.logger.error(exception.backtrace.join("\n")) if exception.respond_to?(:backtrace)
end

def report_exception_to_ets(exception, meta = {})
  return if Rails.env.test? || Rails.env.development?

  if defined?(Bugsnag)
    Bugsnag.notify exception do |b|
      b.meta_data = meta
    end
  end
rescue StandardError => e
  report_exception(e, false)
end
