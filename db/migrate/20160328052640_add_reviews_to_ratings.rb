class AddReviewsToRatings < ActiveRecord::Migration[5.0]
  def change
    add_column :ratings, :review, :text
  end
end
