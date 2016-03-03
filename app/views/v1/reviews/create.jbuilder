review = @review

json.partial! 'v1/reviews/detail', review: review

json.partial! 'v1/items/detail', item: review.item
