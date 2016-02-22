item = @item

json.partial! 'v1/items/show', item: item

publish_detail = item.publish_detail
if publish_detail.present?
  json.publish_detail do
    json.partial! 'v1/publish_details/show', publish_detail: publish_detail
  end
end

json.categories item.categories.pluck(:title)
