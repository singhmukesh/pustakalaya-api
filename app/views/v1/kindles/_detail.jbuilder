json.extract! kindle, :id, :name, :image, :code, :description
json.status kindle.status if @current_user.ADMIN?

json.publish_detail do
  json.partial! 'v1/publish_details/show', publish_detail: kindle.publish_detail
end

json.partial! 'v1/categories/list', item: kindle

json.partial! 'v1/ratings/detail', item: kindle

json.reviews do
  kindle.reviews.each do |review|
    json.partial! 'v1/reviews/detail', review: review
  end
end
