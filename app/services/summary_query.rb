# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Summary query for different models
#
class SummaryQuery
  SUMMARY_MODELS = {
    Deposit => { grouped_by: %i[cc_code status is_dust], aggregations: ['sum(amount)', 'sum(fee)', :total] },
    Withdrawal => { grouped_by: %i[cc_code status], aggregations: ['sum(amount)', 'sum(fee)', 'sum(real_pay_fee)', :total] },
    TransactionAnalysis => { grouped_by: %i[risk_level], aggregations: [:total] },
    AddressAnalysis => { grouped_by: %i[risk_level], aggregations: ['count(risk_level)'] },
    AnalyzedUser => { grouped_by: %w[risk_level_3_count>0], aggregations: [:total], order: '' },
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

    plucks = ((extra_plucks + meta[:aggregations]) - [:total]).map do |p|
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
    return row unless aggregations.include? :total

    count = (aggregations - [:total]).count
    total = if aggregations.join.include? 'debit'
              row.last(2).first - row.last
            else
              binding.pry
              row.slice(row.length - count, count).inject(&:+)
            end
    row + [total]
  end
end
