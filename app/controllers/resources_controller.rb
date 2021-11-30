# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ResourcesController < ApplicationController
  self.default_url_options = Rails.configuration.application.fetch(:default_url_options).symbolize_keys if Rails.configuration.application.try(:key?, :default_url_options)

  include PaginationSupport
  include RansackSupport
  include ShowAction
  include HidedColumns

  layout 'fluid'

  helper_method :model_class

  private

  def model_class
    self.class.name.remove('Controller').singularize.constantize
  end
end
