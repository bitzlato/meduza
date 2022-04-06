class BitzlatoRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :primary, reading: :replica } if Rails.env.production?
end
