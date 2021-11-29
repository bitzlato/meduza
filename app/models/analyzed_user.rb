class AnalyzedUser < ApplicationRecord
  belongs_to :user
  upsert_keys [:user_id]

  has_many :transaction_analyses
end
