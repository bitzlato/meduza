class DashboardController < ApplicationController
  LIMIT = 10
  layout 'fluid'

  def index
    analyzed_users = AnalyzedUser
      .where('risk_level_3_count > 0 ')
      .order('risk_level_3_count desc')
      .limit(LIMIT)
    render locals: { analyzed_users: analyzed_users }
  end
end
