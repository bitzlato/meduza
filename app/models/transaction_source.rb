class TransactionSource < ApplicationRecord
  upsert_keys [:cc_code]

  validates :cc_code, presence: true, uniqueness: true
end
