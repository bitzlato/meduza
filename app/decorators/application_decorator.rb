# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  TEXT_RIGHT = %i[created_at updated_at fee amount address address_transaction risk_level risk_confidence txid user_id].freeze

  def self.table_columns
    object_class.attribute_names.map(&:to_sym)
  end

  def self.table_th_class(column)
    return 'text-right' if TEXT_RIGHT.include? column.to_sym
  end

  def self.table_td_class(column)
    table_th_class column
  end

  def self.table_tr_class(record); end

  def id
    h.link_to object.id, h.url_for(object)
  end

  def self.attributes
    table_columns
  end

  def analysis_result_message
    return '-' if object.analysis_result.nil?
    h.link_to object.analysis_result.message, h.analysis_result_path(object.analysis_result)
  end

  def fee_amount
    h.format_money object.fee_amount, object.blockchain.fee_currency
  rescue RuntimeError # no native currency
    object.fee_amount
  end

  def currency
    h.format_currency object.currency
  end

  def data
    h.content_tag :code, object.data.as_json, class: 'text-small'
  end

  def options
    h.content_tag :span, object.options.as_json, class: 'text-small text-muted text-monospace'
  end

  def updated_at
    present_time object.updated_at
  end

  def created_at
    present_time object.created_at
  end

  def transactions_count
    # TODO: normalize address
    h.link_to object.transactions.count, h.transactions_path(q: { by_address: object.address })
  end

  def from_address
    h.link_to object.blockchain.explore_address_url(object.from_address), target: '_blank', cass: 'text-monospace' do
      h.present_address object.from_address
    end
  end

  def blockchain
    h.link_to h.blockchain_url(object.blockchain) do
      h.content_tag :span, object.blockchain.key, class: 'text-nowrap text-monospace'
    end
  end

  def address
    present_address object.address
  end

  def contract_address
    present_address object.contract_address
  end

  def to_address
    present_address object.to_address
  end

  def rid
    return h.middot unless object.rid?

    h.link_to object.rid, object.blockchain.explore_address_url(object.rid), target: '_blank', class: 'text-monospace'
  end

  def txid
    present_txid object.txid
  end

  def txid_with_recorded_transaction(txid)
    return h.middot unless txid?

    link = present_txid(txid)
    buffer = if object.recorded_transaction.present?
               h.link_to('tx in db #' + object.recorded_transaction.id.to_s, h.transaction_path(object.recorded_transaction.id), class: 'badge badge-primary')
             else
               h.content_tag :span, 'not found in db', class: 'badge badge-warning'
             end
    link << h.content_tag(:div, buffer)
    link
  end

  def reference
    return h.middot if object.reference_id.nil?

    h.link_to object.reference, h.url_for(object.reference)
  end

  def risk_level
    h.present_risk_level object.risk_level
  end

  def risk_confidence
    h.present_risk_confidence object.risk_confidence
  end

  private

  def present_address(address)
    return h.middot if address.nil?

    # h.link_to object.blockchain.explore_address_url(address), target: '_blank', class: 'text-monospace' do
    h.present_address address
    #end
  end

  def present_time(time)
    return if time.nil?
    return time.iso8601 if h.request.format.xlsx?

    h.content_tag :span, class: 'text-nowrap' do
      I18n.l time
    end
  end

  def present_txid(txid)
    return h.middot if txid.nil?

    h.content_tag :span, txid, class: 'text-monospace'
    # h.link_to(txid, object.transaction_url, target: '_blank', class: 'text-monospace')
  end
end
