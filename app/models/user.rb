class User < ApplicationRecord
  self.table_name = :user

  has_many :deposits
  has_many :withdrawal
  has_many :wallets
end
