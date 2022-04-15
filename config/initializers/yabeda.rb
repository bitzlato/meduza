Yabeda.configure do
  default_tag :rails_environment, Rails.env
  group :meduza
  counter :checked_pending_analyses,
    comment: 'A counter of checked PendingAnalyses',
    tags: %i[cc_code type risk_level]
  gauge :pending_analyses_queue_size,
    comment: 'A size on PendingAnalyses queue',
    tags: %i[cc_code type]
  histogram :valega_analyzation_runtime,
    comment: 'How long Valega analyze data',
    buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10, 30],
    tags: %i[cc_code],
    unit: :ms

  collect do
    PendingAnalyses.pending.group(:cc_code, :type).count.each do |( cc_code, type ), size|
      meduza.pending_analyses_queue_size.set({cc_code: cc_code, type: type}, size)
    end
  end
end
