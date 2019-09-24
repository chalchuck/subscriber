class AddBalanceToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :balance, :decimal, precision: 64, scale: 6, default: 0.0
    add_column :invoices, :paid, :decimal, precision: 64, scale: 6, default: 0.0
  end
end
