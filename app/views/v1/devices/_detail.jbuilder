json.extract! device, :id, :name, :image, :code, :description

json.partial! 'v1/categories/index', item: device

json.leases do
  json.array! device.leases.ACTIVE do |lease|
    json.partial! 'v1/leases/show', lease: lease
  end
end
