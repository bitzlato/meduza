class Currency < ApplicationRecord
  before_validation if: :cc_coe do
    self.cc_code = cc_code.upcase
  end
  validates :cc_code, presence: true, uniqueness: true
end
