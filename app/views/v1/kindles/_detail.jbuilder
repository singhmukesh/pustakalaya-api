json.extract! kindle, :name, :image, :code, :description

json.publish_detail do
  json.partial! 'v1/publish_details/show', publish_detail: kindle.publish_detail
end

json.partial! 'v1/categories/index', item: kindle
