# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module HidedColumns
  extend ActiveSupport::Concern

  included do
    before_action do
      session[hided_columns_key] = params[:hide_columns] if params.key? :hide_columns
    end
    helper_method :hided_columns
  end

  private

  def hided_columns_key
    controller_name + '_hided_columns'
  end

  def hided_columns
    Array(session[hided_columns_key]).uniq.freeze
  end
end
