module ApplicationHelper
  def sort_column(column, title)
    sort_link q, column, title
  end

  def middot
    content_tag :div, '&middot;'.html_safe, class: 'text-muted'
  end

  def app_title
    'meduza'
  end

  def present_time(time)
    content_tag :div, class: 'text-nowrap text-muted text-small', title: I18n.l(time, format: :default) do
      time_ago_in_words time
    end
  end

  def present_address(address)
    content_tag(:div, address, class: 'text-monospace')
  end

  def download_link(url = nil, size = nil)
    title = size.present? ? t('helpers.download_with_size', ext: 'xlsx', size: size) : t('helpers.download_without_size', ext: 'xlsx')
    link_to url || url_for(q: params.fetch(:q, {}).permit!.to_hash, format: :xlsx), class: 'text-nowrap' do
      content_tag(:span, '⬇', class: 'mr-1') + title
    end
  end
end
