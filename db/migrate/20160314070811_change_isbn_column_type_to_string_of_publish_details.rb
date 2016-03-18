class ChangeIsbnColumnTypeToStringOfPublishDetails < ActiveRecord::Migration[5.0]
  def change
    change_column :publish_details, :isbn, :string
  end
end
