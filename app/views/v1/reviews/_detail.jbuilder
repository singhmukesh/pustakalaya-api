json.extract! review, :description
json.user do
  json.partial! 'v1/users/detail', user: review.user
end
