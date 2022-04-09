class DashboardController < ApplicationController
  LIMIT = 10
  layout 'fluid'

  def index
    analyzed_users = AnalyzedUser
      .order('danger_transactions_count desc, updated_at')
      .limit(LIMIT)
    render locals: { analyzed_users: analyzed_users }
  end
end
