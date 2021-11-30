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
end
