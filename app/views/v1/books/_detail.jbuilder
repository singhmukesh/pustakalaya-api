json.extract! book, :name, :image, :code, :description

json.publish_detail do
  json.partial! 'v1/publish_details/show', publish_detail: book.publish_detail
end

json.partial! 'v1/categories/index', item: book

json.available book.available?.to_s

json.leases do
  book.leases.ACTIVE.each do |lease|
    json.partial! 'v1/leases/show', lease: lease
  end
end
