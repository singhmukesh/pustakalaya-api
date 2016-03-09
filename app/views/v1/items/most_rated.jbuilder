items = @items
books = items.books
kindles = items.kindles

json.partial! 'v1/books/listing', books: books if books.present?
json.partial! 'v1/kindles/listing', kindles: kindles if kindles.present?

json.partial! 'v1/shared/pagination', collection: items
