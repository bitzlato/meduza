class AnalyzedUsersController < ResourcesController

  private

  def default_sort
    'risk_level_3_count desc'
  end
end
