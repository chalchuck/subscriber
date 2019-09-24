class CreateSubscribeTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscribe_transactions do |t|
      t.string :origin
      t.string :msisdn, index: true
      t.string :sender, index: true
      t.decimal :actual_amount, precision: 64, scale: 5
      t.decimal :trans_amount, precision: 64, scale: 5
      t.string :bill_ref_number, index: true
      t.string :trans_id, index: true, unique: true
      t.datetime :trans_time
      t.belongs_to :business, foreign_key: true
      t.belongs_to :customer, foreign_key: true
      t.belongs_to :invoice, foreign_key: true
      t.belongs_to :subscription, foreign_key: true
      t.jsonb :raw_transaction

      t.timestamps
    end
  end
end
