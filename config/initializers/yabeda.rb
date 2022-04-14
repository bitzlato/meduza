Yabeda.configure do
  default_tag :rails_environment, Rails.env
  group :meduza
  counter :checked_pending_analyses,
    comment: 'A counter of checked PendingAnalyses',
    tags: %i[cc_code type]
  gauge :pending_analyses_queue_size,
    comment: 'A size on PendingAnalyses queue',
    tags: %i[cc_code type]

  gauge :valega_analyzation_runtime,
    comment: 'How long Valega analyze data',
    tags: %i[cc_code]

  collect do
    PendingAnalyses.pending.group(:cc_code, :type).count.each do |( cc_code, type ), size|
      meduza.pending_analyses_queue_size.set({cc_code: cc_code, type: type}, size)
    end
  end
end
