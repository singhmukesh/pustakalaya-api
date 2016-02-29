if item.type == Book.to_s
  json.partial! 'v1/books/detail', book: item
elsif item.type == Device.to_s
  json.partial! 'v1/devices/detail', device: item
elsif item.type == Kindle.to_s
  json.partial! 'v1/kindles/detail', kindle: item
end
