rating = @rating

json.rating rating, :value

json.partial! 'v1/items/detail', item: rating.item
