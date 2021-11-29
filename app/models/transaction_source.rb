class TransactionSource < ApplicationRecord
  upsert_keys [:name, :cc_code]

  validates :name, presence: true
  validates :cc_code, presence: true, uniqueness: { scope: :name }
end
