module HiddenColumnsHelper
  EMPTY_ARRAY = ['_']

  def hide_column(column)
    link_to '[×]', url_for(
      q: params.fetch(:q, {}).permit!,
      hide_columns: hidden_columns + [column]
    ), class: 'ml-2'
  end

  def unhide_all_url
    url_for(
      hide_columns: EMPTY_ARRAY
    )
  end

  def unhide_column_url(column)
    url_for(
      q: params.fetch(:q, {}).permit!,
      hide_columns: hidden_columns - [column] + EMPTY_ARRAY
    )
  end
end
