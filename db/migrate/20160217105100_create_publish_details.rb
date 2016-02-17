class CreatePublishDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :publish_details do |t|
      t.integer :isbn,                        null: false
      t.string :author,                       null: false
      t.date :publish_date,                 null: false
      t.references :item, foreign_key: true,  null: false

      t.timestamps
    end
  end
end
