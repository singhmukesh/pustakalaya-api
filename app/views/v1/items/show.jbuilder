item = @item

json.partial! 'v1/items/detail', item: item

if item.is_readable
  json.goodreads do
    json.partial! 'v1/publish_details/goodreads', goodreads: item.publish_detail.goodreads
  end
end
