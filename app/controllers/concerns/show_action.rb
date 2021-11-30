# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module ShowAction
  extend ActiveSupport::Concern
  included do
    helper_method :q
  end

  def show
    render locals: { record: record }
  end

  private

  def record
    model_class.find params[:id]
  end
end
