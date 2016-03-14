json.kindles do
  json.array! kindles do |kindle|
    json.partial! 'v1/items/detail', item: kindle
  end
end
