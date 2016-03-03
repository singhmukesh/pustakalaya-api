books = @books

json.books do
  json.array! books do |book|
    json.partial! 'v1/items/detail', item: book

    json.publish_detail do
      json.partial! 'v1/publish_details/show', publish_detail: book.publish_detail
    end

    json.categories book.categories.pluck(:title)
  end
end

json.partial! 'v1/shared/pagination', collection: books
