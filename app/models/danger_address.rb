class DangerAddress < ApplicationRecord
  belongs_to :analyzed_user, counter_cache: true

  validates :address, presence: true
end
