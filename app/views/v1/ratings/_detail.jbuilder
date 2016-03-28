json.ratings do
  json.array! item.ratings.order(updated_at: :desc) do |rating|
    json.extract! rating, :value, :review
    json.user do
      json.partial! 'v1/users/detail', user: rating.user
    end
  end
end

json.average_rating item.rating
