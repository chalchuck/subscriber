class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.datetime :due_date
      t.text :description
      t.string :status, default: "new"
      t.string :currency, default: "KES"
      t.decimal :amount_due, precision: 32, scale: 4
      t.string :identifier, index: true, unique: true
      t.string :receipt_number, index: true, unique: true

      t.belongs_to :customer, foreign_key: true
      t.belongs_to :business, foreign_key: true
      t.belongs_to :subscription, foreign_key: true

      t.timestamps
    end
  end
end
