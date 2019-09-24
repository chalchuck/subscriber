class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :name, index: true
      t.string :email, index: true, unique: true
      t.string :identifier, index: true, unique: true
      t.string :phone_number, index: true, unique: true
      t.string :fantasy_name, index: true, unique: true

      t.timestamps
    end
  end
end
