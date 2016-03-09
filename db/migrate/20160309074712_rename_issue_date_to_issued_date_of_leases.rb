class RenameIssueDateToIssuedDateOfLeases < ActiveRecord::Migration[5.0]
  def change
    rename_column :leases, :issue_date, :issued_date
  end
end
