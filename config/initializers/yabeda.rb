LONG_RUNNING_REQUEST_BUCKETS = [
  0.5, 1, 2.5, 5, 10, 25, 50, 100, 250, 500, 1000, # standard
  30_000, 60_000, 120_000, 300_000, 600_000 # slow queries
].freeze

Yabeda.configure do
  default_tag :rails_environment, Rails.env
  group :meduza
  counter :checked_pending_analyses,
    comment: 'A counter of checked PendingAnalyses',
    tags: %i[cc_code type risk_level]

  gauge :pending_analyses_queue_size,
    comment: 'A size on PendingAnalyses queue',
    tags: %i[cc_code type]

  counter :valega_request_total,
    comment: 'A counter of the total number of external Valega HTTP \
               requests.',
    tags: %i[cc_code]

  histogram :valega_request_runtime,
    comment: 'How long Valega analyze data',
    buckets: LONG_RUNNING_REQUEST_BUCKETS,
    tags: %i[cc_code],
    unit: :milliseconds

  counter :scorechain_request_total,
    comment: 'A counter of the total number of external Valega HTTP \
               requests.',
    tags: %i[cc_code]

  histogram :scorechain_request_runtime,
    comment: 'How long Scorechain analyze data',
    buckets: LONG_RUNNING_REQUEST_BUCKETS,
    tags: %i[cc_code],
    unit: :milliseconds

  collect do
    Currency.
      cc_codes.
      map { |cc_code| PendingAnalysis::TYPES.map { |type| [cc_code, type] } }.
      each_with_object({}) { |keys, ag| keys.each { |key| ag[key]= 0 } }.
      merge(PendingAnalysis.pending.group(:cc_code, :type).count).
      each do |( cc_code, type ), size|
      meduza.pending_analyses_queue_size.set({cc_code: cc_code, type: type}, size)
    end
  end
end
