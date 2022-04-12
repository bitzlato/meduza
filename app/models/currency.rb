class Currency < ApplicationRecord

  scope :paused, -> { where status: :pause }

  before_validation if: :cc_code do
    self.cc_code = cc_code.upcase
  end
  validates :cc_code, presence: true, uniqueness: true

  STATUSES = %w[check skip pause]

  validates :status, presence: true, inclusion: { in: STATUSES }

  validate :available_status

  def to_s
    cc_code
  end

  def check?
    status == 'check'
  end

  def skip?
    status == 'skip'
  end

  def pause?
    status == 'pause'
  end

  def valega_support?
    VALEGA_ASSETS_CODES.include? cc_code
  end

  def based
    return :ethereum if ETHEREUM_CODES.include? cc_code
    return :bitcoin if BITCOIN_FORKS.include? cc_code
    :unknown
  end

  def available_to_check?
    valega_support?
  end

  def available_status
    errors.add :status, 'Проверка не поддерживается' if check? && !available_to_check?
  end
end
