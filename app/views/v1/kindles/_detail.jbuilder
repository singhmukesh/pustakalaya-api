json.extract! kindle, :id, :name, :image, :code, :description

json.publish_detail do
  json.partial! 'v1/publish_details/show', publish_detail: kindle.publish_detail
end

json.partial! 'v1/categories/list', item: kindle

json.partial! 'v1/ratings/detail', item: kindle

json.reviews do
  json.array! kindle.reviews.order(created_at: :desc) do |review|
    json.partial! 'v1/reviews/detail', review: review
  end
end
