json.extract! kindle, :id, :name, :image, :code, :description, :is_readable, :is_leaseable, :is_rateable
json.is_auto_lease true

json.publish_detail do
  json.partial! 'v1/publish_details/show', publish_detail: kindle.publish_detail
end

json.partial! 'v1/categories/list', item: kindle

json.partial! 'v1/ratings/detail', item: kindle
