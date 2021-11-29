class AnalyzedUsersController < ApplicationController
  include PaginationSupport

  layout 'fluid'

  def index
    scope = AnalyzedUser
      .where('risk_level_3_count > 0 ')
      .order('risk_level_3_count desc')
    render locals: { analyzed_users: paginate(scope) }
  end

  def show
    render locals: { analyzed_user: AnalyzedUser.find(params[:id]) }
  end
end
