class Withdrawal < ApplicationRecord
  WrongStatus = Class.new StandardError

  self.table_name = :withdrawal

  belongs_to :user
  belongs_to :wallet
  belongs_to :blockchain_tx

  belongs_to :currency, foreign_key: :cc_code, primary_key: :cc_code

  scope :aml, -> { where status: :aml }

  def pending!(meduza_status)
    with_lock do
      raise WrongStatus, "with_lock wrong status #{status}, skip [id: #{id}]" unless status == 'aml'
      update_columns status: :pending, meduza_status: meduza_status
    end
  end
end
