class Withdrawal < ApplicationRecord
  self.table_name = :withdrawal

  belongs_to :user
  belongs_to :wallet
  belongs_to :blockchain_tx

  scope :aml, -> { where status: :aml }

  def pending!
    update! status: :pending
  end
end
