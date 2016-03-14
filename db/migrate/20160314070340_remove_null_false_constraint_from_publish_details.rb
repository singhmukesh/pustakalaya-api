class RemoveNullFalseConstraintFromPublishDetails < ActiveRecord::Migration[5.0]
  def change
    change_column_null :publish_details, :isbn, true
    change_column_null :publish_details, :publish_date, true
  end
end
