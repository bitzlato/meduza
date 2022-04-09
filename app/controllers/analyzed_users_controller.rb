class AnalyzedUsersController < ResourcesController

  private

  def default_sort
    'danger_transactions_count desc, danger_addresses_count desc'
  end
end
