json.extract! book, :id, :name, :image, :code, :description, :quantity, :is_readable, :is_leaseable, :is_rateable

json.is_auto_lease true

json.publish_detail do
  json.partial! 'v1/publish_details/show', publish_detail: book.publish_detail
end

json.partial! 'v1/categories/list', item: book

json.available book.available?

json.lease @current_user.leased? book.id

json.watch @current_user.watched? book.id

json.leases do
  json.array! book.leases.ACTIVE.order(created_at: :desc) do |lease|
    json.partial! 'v1/leases/detail', lease: lease
  end
end

json.partial! 'v1/ratings/detail', item: book
