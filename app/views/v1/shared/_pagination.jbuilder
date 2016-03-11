json.pagination do
  total_pages = list.present? ? list.total_pages : 0
  current_page = list.present? ? list.current_page : 0

  json.total_pages total_pages
  json.current_page current_page
  json.per_page list.per_page
end
