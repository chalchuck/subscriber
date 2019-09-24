class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
      t.string :identifier
      t.boolean :active, default: true
      t.integer :times_redeemed, default: 0
      t.datetime :redeem_by
      t.string :duration
      t.string :currency, default: "KES"
      t.decimal :percent_off, precision: 64, scale: 6
      t.decimal :amount_off, precision: 64, scale: 6
      t.jsonb :metadata, default: {}

      t.references :user, foreign_key: true
      t.references :business, foreign_key: true

      t.timestamps
    end
  end
end
