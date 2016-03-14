json.devices do
  json.array! devices do |device|
    json.partial! 'v1/items/detail', item: device
  end
end
