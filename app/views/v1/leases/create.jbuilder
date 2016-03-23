lease = @lease

json.partial! 'v1/leases/detail', lease: lease
