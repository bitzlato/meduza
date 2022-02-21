# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module HiddenColumns
  extend ActiveSupport::Concern

  included do
    before_action do
      session[hidden_columns_key] = params[:hide_columns] - HiddenColumnsHelper::EMPTY_ARRAY if params.key? :hide_columns
    end
    helper_method :hidden_columns
  end

  private

  def hidden_columns_key
    controller_name + '_hidden_columns'
  end

  def hidden_columns
    Array(session[hidden_columns_key]).uniq.freeze
  end
end
