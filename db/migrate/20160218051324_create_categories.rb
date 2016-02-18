class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :title,  null: false, unique: true
      t.integer :group, null: false

      t.timestamps
    end
  end
end
