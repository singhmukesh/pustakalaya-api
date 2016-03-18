items = @items
books = items.books
devices = items.devices

json.partial! 'v1/books/listing', books: books
json.partial! 'v1/devices/listing', devices: devices

json.partial! 'v1/shared/pagination', list: items
