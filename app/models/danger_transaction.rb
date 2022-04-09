class DangerTransaction < ApplicationRecord
  belongs_to :analyzed_user, counter_cache: true

  validates :txid, presence: true
end
