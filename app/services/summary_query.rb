# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Summary query for different models
#
class SummaryQuery
  SUMMARY_MODELS = {
    TransactionAnalysis => { grouped_by: %i[direction risk_level], aggregations: ['count(id)'] },
    AddressAnalysis     => { grouped_by: %i[risk_level], aggregations: ['count(address_analyses.risk_level)'] },
    AnalysisResult      => { grouped_by: %w[type cc_code risk_confidence risk_level], aggregations: [:risk_confidence, :risk_level, 'count(id)'] },
    PendingAnalysis     => { grouped_by: %w[state cc_code source type], aggregations: ['count(id)'] },
    DangerTransaction   => { grouped_by: %w[cc_code], aggregations: ['count(id)'] },
    DangerAddress       => { grouped_by: %w[cc_code], aggregations: ['count(id)'] },
  }.freeze

  # rubocop:disable Metrics/MethodLength
  def summary(scope)
    model_class = scope.model
    return unless SUMMARY_MODELS[model_class].present?

    meta = SUMMARY_MODELS[model_class]

    if meta[:grouped_by].join.include? '>'
      extra_plucks = []
    else
      extra_plucks = meta[:grouped_by]
    end

    order = meta[:order] || meta[:grouped_by].first

    plucks = ((extra_plucks + meta[:aggregations])).map do |p|
      p.to_s.include?('(') || p.to_s.include?('.') ? p : [model_class.table_name, p].join('.')
    end

    scope = scope
           .group(*meta[:grouped_by])
           .reorder('')
           .order(order)

    if plucks.any?
      scope = scope.pluck(plucks.join(', '))
    else
      scope = scope.count
    end
    rows = scope
           .map { |row| prepare_row row, meta[:aggregations] }

    {
      grouped_by: meta[:grouped_by],
      aggregations: meta[:aggregations],
      rows: rows
    }
  end
  # rubocop:enable Metrics/MethodLength

  private

  def prepare_row(row, aggregations)
    row
  end
end
