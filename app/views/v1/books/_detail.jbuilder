json.extract! book, :id, :name, :image, :code, :description

json.publish_detail do
  json.partial! 'v1/publish_details/show', publish_detail: book.publish_detail
end

json.partial! 'v1/categories/list', item: book

json.available book.available?.to_s

json.lease @current_user.leased? book.id

json.watch @current_user.watched? book.id

json.leases do
  book.leases.ACTIVE.each do |lease|
    json.partial! 'v1/leases/detail', lease: lease
  end
end

json.partial! 'v1/ratings/detail', item: book

json.reviews do
  book.reviews.each do |review|
    json.partial! 'v1/reviews/detail', review: review
  end
end

