class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.string :identifier
      t.string :currency
      t.text   :description
      t.string :name, index: true
      t.string :email, index: true, unique: true
      t.string :mobile_number, index: true, unique: true
      t.belongs_to :business, foreign_key: true

      t.timestamps
    end
  end
end
