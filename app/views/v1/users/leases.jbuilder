user = @user

json.partial! 'v1/users/show', user: user

json.leases do
  json.array! user.leases.ACTIVE do |lease|
    json.partial! 'v1/leases/detail', lease: lease
    json.partial! 'v1/items/detail', item: lease.item
  end
end
