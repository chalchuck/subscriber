class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.string :identifier
      t.integer :quantity
      t.datetime :start
      t.string :status
      t.belongs_to :business, foreign_key: true

      t.timestamps
    end
  end
end
