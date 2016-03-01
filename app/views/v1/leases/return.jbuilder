lease = @lease

json.partial! 'v1/leases/show', lease: lease

json.partial! 'v1/items/detail', item: lease.item
