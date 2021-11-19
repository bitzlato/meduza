module ApplicationHelper
  def app_title
    'meduza'
  end

  def present_time(time)
    content_tag :div, class: 'text-nowrap text-muted text-small', title: I18n.l(time, format: :default) do
      time_ago_in_words time
    end
  end
end
