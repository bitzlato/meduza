# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module PaginationSupport
  extend ActiveSupport::Concern
  included do
    helper_method :per_page, :page
  end

  private

  def per_page
    params[:per]
  end

  def page
    params[:page]
  end

  def per_page_default
    Rails.env.development? ? 5 : 100
  end

  def paginate(scope)
    scope
      .page(page)
      .per(per_page || per_page_default)
  end
end
