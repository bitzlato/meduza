# frozen_string_literal: true

class OutdatedPendingAnalysisChecker < ApplicationJob
  CACHE_KEY = 'outdated_pending_analysis'

  def perform
    pending_analysis = PendingAnalysis.pending.outdated

    ids = pending_analysis.ids
    old_ids = retive_ids
    new_ids = ids - old_ids

    if new_ids.any?
      message = %(:warning: Есть зависшие проверки\n#{new_ids.map { |id| "https://meduza.lgk.one/pending_analyses/#{id}" }.join("\n")})
      SlackNotifier.notifications.ping(message)
    end

    update_ids(ids)
  end

  private

  # rubocop:disable Security/MarshalLoad
  def retive_ids
    redis.get(CACHE_KEY).then { |res| res.present? ? Marshal.load(res) : [] }
  end
  # rubocop:enable Security/MarshalLoad

  def update_ids(ids)
    redis.set(CACHE_KEY, Marshal.dump(ids))
  end

  def redis
    @redis ||= Redis.new url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')
  end
end
