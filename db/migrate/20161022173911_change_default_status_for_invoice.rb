class ChangeDefaultStatusForInvoice < ActiveRecord::Migration[5.0]
  def up
    change_column :invoices, :status, :string, default: "verynew"
  end

  def down
    change_column :invoices, :status, :string, default: "new"
  end
end
