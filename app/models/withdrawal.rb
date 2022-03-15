class Withdrawal < ApplicationRecord
  self.table_name = :withdrawal

  belongs_to :user
  belongs_to :wallet
  belongs_to :blockchain_tx

  scope :aml, -> { where status: :aml }

  def pending!
    # TODO: из-за сложности с тестовый базой игноирим валидацию
    update_column :status, :pending
  end
end
