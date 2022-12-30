class FrozenPendingAnalysisChecker < ActiveJob::Base
  queue_as :default
  CACHE_KEY = 'outdated_pending_analysis'

  def perform
    pending_analysis = PendingAnalysis.pending.outdated

    ids = pending_analysis.ids
    old_ids = get_ids
    new_ids = ids - old_ids

    if new_ids.any?
      message = %Q{:warning: Есть зависшие проверки\n#{new_ids.map { |id| "https://meduza.lgk.one/pending_analyses/#{id}" }.join("\n") }}
      SlackNotifier.notifications.ping(message)
    end

    update_ids(ids)
  end

  private

  def get_ids
    redis.get(CACHE_KEY).then { |res| res.present? ? Marshal.load(res) : [] }
  end

  def update_ids(ids)
    redis.set(CACHE_KEY, Marshal.dump(ids))
  end

  def redis
    @redis ||= Redis.new url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')
  end
end
