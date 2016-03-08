users = @users

json.users do
  json.array! users do |user|
    json.partial! 'v1/users/detail', user: user
  end
end
