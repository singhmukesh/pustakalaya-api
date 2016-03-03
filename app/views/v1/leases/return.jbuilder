lease = @lease

json.partial! 'v1/leases/detail', lease: lease

json.partial! 'v1/items/detail', item: lease.item
