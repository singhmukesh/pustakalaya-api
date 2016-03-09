json.extract! lease, :id
json.issued_date lease.issued_date.to_i
json.due_date lease.due_date.to_i
json.return_date lease.return_date.to_i if lease.return_date.present?
json.renew_count lease.renew_count if lease.item.type == Book.to_s

json.user do
  json.partial! 'v1/users/detail', user: lease.user
end
