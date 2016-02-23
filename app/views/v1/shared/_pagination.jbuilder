json.pagination do
  json.total_pages collection.total_pages
  json.current_page collection.current_page
  json.per_page collection.per_page
end
