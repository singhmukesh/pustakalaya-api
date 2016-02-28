user = @user

json.extract! user, :name, :email, :image

json.leases do
  json.array! user.leases.ACTIVE do |lease|
    json.partial! 'v1/leases/show', lease: lease
    json.partial! 'v1/items/detail', item: lease.item
  end
end

json.watches do
  json.array! user.watches.ACTIVE do |watch|
    json.partial! 'v1/items/detail', item: watch.item
  end
end
