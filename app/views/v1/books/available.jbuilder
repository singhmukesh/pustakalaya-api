books = @books

json.partial! 'v1/books/listing', books: books
