items = @items
books = items.books
kindles = items.kindles
devices = items.devices

json.partial! 'v1/books/listing', books: books
json.partial! 'v1/kindles/listing', kindles: kindles
json.partial! 'v1/devices/listing', devices: devices

json.partial! 'v1/shared/pagination', collection: items
