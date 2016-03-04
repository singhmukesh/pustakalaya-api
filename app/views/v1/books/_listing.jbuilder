json.books do
  json.array! books do |book|
    json.partial! 'v1/items/detail', item: book

    json.publish_detail do
      json.partial! 'v1/publish_details/show', publish_detail: book.publish_detail
    end

    json.partial! 'v1/categories/list', item: book
  end
end
