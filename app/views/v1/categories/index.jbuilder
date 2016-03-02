categories = @categories

json.categories do
  json.array! categories do |category|
    json.extract! category, :id, :title, :group
  end
end
