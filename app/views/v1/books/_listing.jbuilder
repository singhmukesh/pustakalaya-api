json.books do
  json.array! books do |book|
    json.partial! 'v1/items/detail', item: book
  end
end
