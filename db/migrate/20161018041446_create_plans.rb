class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :identifier
      t.string :name, index: true
      t.decimal :amount, precision: 10, scale: 3
      t.string :currency, default: "KES"
      t.string :interval
      t.integer :interval_count, default: 1
      t.boolean :livemode
      t.text :description
      t.datetime :start
      t.belongs_to :business

      t.timestamps
    end
  end
end
