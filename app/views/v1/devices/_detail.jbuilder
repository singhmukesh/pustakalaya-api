json.extract! device, :id, :name, :image, :code, :description, :is_readable, :is_leaseable, :is_rateable
json.is_auto_lease false

json.partial! 'v1/categories/list', item: device

json.lease @current_user.leased? device.id

json.leases do
  json.array! device.leases.ACTIVE do |lease|
    json.partial! 'v1/leases/detail', lease: lease
  end
end
