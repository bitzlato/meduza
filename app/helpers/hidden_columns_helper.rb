module HiddenColumnsHelper
  def hide_column(column)
    link_to '[×]', url_for(
      q: params.fetch(:q, {}).permit!,
      hide_columns: hided_columns + [column]
    ), class: 'ml-2'
  end

  def unhide_all_url
    url_for(
      hided_columns: ['_']
    )
  end

  def unhide_column_url(column)
    url_for(
      q: params.fetch(:q, {}).permit!,
      hide_columns: hided_columns - [column] + ['_']
    )
  end
end
