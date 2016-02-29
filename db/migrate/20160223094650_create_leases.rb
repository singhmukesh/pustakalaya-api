class CreateLeases < ActiveRecord::Migration[5.0]
  def change
    create_table :leases do |t|
      t.datetime :issue_date,     null: false
      t.datetime :due_date,       null: false
      t.datetime :return_date
      t.integer :status,      null: false, default: 0
      t.integer :renew_count, null: false, default: 0
      t.references :user,     foreign_key: true
      t.references :item,     foreign_key: true

      t.timestamps
    end
  end
end
