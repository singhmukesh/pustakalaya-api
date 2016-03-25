if goodreads
  json.average_rating goodreads[:average_rating].to_f
  json.ratings_count goodreads[:ratings_count].to_f
  json.reviews_widget goodreads[:reviews_widget]
end
