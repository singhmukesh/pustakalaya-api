json.kindles do
  json.array! kindles do |kindle|
    json.partial! 'v1/items/detail', item: kindle

    json.publish_detail do
      json.partial! 'v1/publish_details/show', publish_detail: kindle.publish_detail
    end
  end
end
