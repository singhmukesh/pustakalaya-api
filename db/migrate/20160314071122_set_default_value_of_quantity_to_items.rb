class SetDefaultValueOfQuantityToItems < ActiveRecord::Migration[5.0]
  def change
    change_column :items, :quantity, :integer, default: 1
  end
end
