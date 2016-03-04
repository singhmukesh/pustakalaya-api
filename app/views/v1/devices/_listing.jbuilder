json.devices do
  json.array! devices do |device|
    json.partial! 'v1/items/detail', item: device

    json.partial! 'v1/categories/list', item: device
  end
end
