class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name,           null: false
      t.string :code,           null: false
      t.integer :quantity,      null: false
      t.text :description,      null: false
      t.string :image,          null: false
      t.integer :status,        null: false, default: 0
      t.boolean :is_readable
      t.boolean :is_leaseable
      t.boolean :is_rateable
      t.boolean :is_reviewable
      t.string :type,           null: false

      t.timestamps
    end
  end
end
