items = @items
books = items.books
devices = items.devices

json.partial! 'v1/books/listing', books: books if books.present?
json.partial! 'v1/devices/listing', devices: devices if devices.present?

json.partial! 'v1/shared/pagination', collection: items
