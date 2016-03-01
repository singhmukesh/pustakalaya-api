json.extract! device, :id, :name, :image, :code, :description
json.status book.status if @current_user.ADMIN?

json.partial! 'v1/categories/index', item: device

json.leases do
  json.array! device.leases.ACTIVE do |lease|
    json.partial! 'v1/leases/detail', lease: lease
  end
end
