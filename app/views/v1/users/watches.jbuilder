watches = @watches

json.watches do
  json.array! watches do |watch|
    json.partial! 'v1/items/detail', item: watch.item
  end
end
