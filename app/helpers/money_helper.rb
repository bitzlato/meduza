# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module MoneyHelper
  MAX_PRECISION = 8

  def present_fee(fee, amount = nil)
    content_tag :span, class: 'text-nowrap text-monospace' do
      buffer = (fee * 100).to_s + '%'
      buffer << amount * fee if amount
      buffer
    end
  end

  def format_divergence(amount, currency = nil, options = {})
    if amount.zero?
      content_tag :span, class: 'text-success' do
        t('helpers.no_divergence')
      end
    else
      money = format_money amount, currency, options.reverse_merge(css_class: 'text-warning', tooltip: 'Должно быть 0')
      money = content_tag :div, money, data: { divergence: 'true' } if options.fetch(:tracked, true)
      money
    end
  end

  def compare_amounts(estimated, actual)
    return [:nagative, actual - estimated] if estimated > actual
    return [:positive, actual - estimated] if actual > estimated

    nil
  end

  # @param amount Decimal
  # @param currency [Currency, String]
  # @param options [Hash] :tooltip, :css_class, :show_currency
  def format_money(amount, currency = nil, options = {})
    # Return as is for export
    return amount if request.format.xlsx?

    amount = amount.to_d if amount.is_a? String
    if amount.is_a? Money
      currency = amount.currency
      amount = amount.to_d
    end
    options = options.symbolize_keys.reverse_merge show_currency: true
    precision = 8
    css_classes = %w[text-nowrap text-monospace]
    css_classes << options[:css_class]
    if currency.nil?
      amount
    else
      buffer = money_precission(amount, precision)
      buffer += format_currency(currency, css_class: 'text-muted ml-1') if options[:show_currency] && !amount.nil?
      content_tag :span, class: css_classes.join(' '), title: options[:tooltip].presence || amount.to_d, data: { toggle: :tooltip } do
        buffer.html_safe
      end
    end
  end

  def money_precission(amount, precision)
    return middot if amount.nil?
    return '0' if amount.zero?
    return amount.to_i.to_s if amount.to_i == amount

    precised = format("%0.#{precision}f", amount)
    return precised if precised.to_d == amount

    format("%0.#{MAX_PRECISION}f", amount)
  end

  def format_currency(currency_id, css_class: '')
    content_tag :span, currency_id.to_param, class: "text-nowrap text-uppercase text-monospace #{css_class}"
  end
end
