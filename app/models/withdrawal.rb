class Withdrawal < ApplicationRecord
  WrongStatus = Class.new StandardError

  self.table_name = :withdrawal

  belongs_to :user
  belongs_to :wallet
  belongs_to :blockchain_tx

  belongs_to :currency, foreign_key: :cc_code, primary_key: :cc_code
end
