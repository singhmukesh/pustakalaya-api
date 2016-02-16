class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :role,  null: false, default: 0
      t.string :name,   null: false
      t.string :email,  null: false, unique: true
      t.string :uid,    null: false
      t.string :image

      t.timestamps
    end
  end
end
