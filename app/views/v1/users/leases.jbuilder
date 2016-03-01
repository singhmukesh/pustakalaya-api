leases = @leases

json.leases do
  json.array! leases do |lease|
    json.partial! 'v1/items/detail', item: lease.item
  end
end
