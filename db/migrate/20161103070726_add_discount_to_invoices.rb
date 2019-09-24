class AddDiscountToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :discount, :decimal, precision: 64, scale: 6
    add_column :invoices, :relief, :decimal, precision: 64, scale: 6
  end
end
