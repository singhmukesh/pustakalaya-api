class DropReviews < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :is_reviewable
  end

  def down
    drop_table :reviews
  end
end
