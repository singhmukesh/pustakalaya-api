json.pagination do
  unless list.present?
    total_pages, current_page = 1
  else
    total_pages, current_page = list.total_pages, list.current_page
  end

  json.total_pages total_pages || 1
  json.current_page current_page || 1
  json.per_page list.per_page || 1
end
