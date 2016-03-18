leases = @leases

json.leases do
  json.array! leases do |lease|
    json.partial! 'v1/leases/detail', lease: lease
    json.set! lease.item.type.downcase do
      json.partial! 'v1/items/detail', item: lease.item
    end
  end
end

json.partial! 'v1/shared/pagination', list: leases
