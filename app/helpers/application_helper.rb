module ApplicationHelper
  def active_class(css_classes, flag)
    flag ? "#{css_classes} active" : css_classes
  end

  def back_link(url = nil)
    link_to ('&larr; ' + t('.back')).html_safe, url || root_url
  end

  def sort_column(column, title)
    sort_link q, column, title
  end

  def middot
    content_tag :div, '&middot;'.html_safe, class: 'text-muted'
  end

  def app_title
    'meduza'
  end

  PENDING_CSS_CLASSES = {
    'pending' => 'badge badge-warning',
    'done' => 'badge badge-success',
    'errored' => 'badge badge-danger',
    'skipped' => 'badge badge-info',
  }

  def pending_state(state)
    content_tag :span, state, class: PENDING_CSS_CLASSES[state.to_s]
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
