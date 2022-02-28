# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module RansackSupport
  extend ActiveSupport::Concern
  included do
    helper_method :q, :index_form
  end

  def index
    # We can't raise it from format.xlsx because it will be downloaded
    raise HumanizedError, 'Too many records' if request.format.xlsx? && records.count > Rails.configuration.application.fetch(:max_export_records_count)

    respond_to do |format|
      format.xlsx do
        render locals: {
          records: records
        }
      end
      format.html do
        render locals: {
          records: records,
          summary: SummaryQuery.new.summary(records),
          paginated_records: paginate(records)
        }
      end
      format.csv do
        headers["X-Accel-Buffering"] = "no"
        headers["Cache-Control"] = "no-cache"
        headers["Content-Type"] = "text/csv; charset=utf-8"
        headers["Content-Disposition"] = %(attachment; filename="#{csv_filename}")
        headers["Last-Modified"] = Time.zone.now.ctime.to_s
        self.response_body = CsvBuilder.new(records).enumerator
      end
    end
  end

  private

  def csv_filename
    "#{model_class.name.underscore.pluralize}-#{Time.zone.now.to_date.to_s(:default)}.csv"
  end

  def index_form
    'index_form'
  end

  def q
    @q ||= build_q
  end

  def build_q
    qq = model_class.ransack(params[:q])
    qq.sorts = default_sort if qq.sorts.empty?
    qq
  end

  def default_sort
    'created_at desc'
  end

  def records
    q.result.includes(model_class.reflections.select { |_k, r| r.is_a?(ActiveRecord::Reflection::BelongsToReflection) && !r.options[:polymorphic] }.keys)
  end
end
