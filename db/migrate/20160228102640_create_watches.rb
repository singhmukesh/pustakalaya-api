class CreateWatches < ActiveRecord::Migration[5.0]
  def change
    create_table :watches do |t|
      t.integer :status,   null: false,      default: 0
      t.references :item,  foreign_key: true
      t.references :user,  foreign_key: true

      t.timestamps
    end
  end
end
