json.categories do
  json.array! item.categories do |category|
    json.extract! category, :id, :title
  end
end
