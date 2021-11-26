class Wallet < ApplicationRecord
  self.table_name = :wallet

  belongs_to :user
end
