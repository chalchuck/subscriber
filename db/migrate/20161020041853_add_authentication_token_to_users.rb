class AddAuthenticationTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mobile_number, :string, index: true, unique: true
    add_column :users, :authentication_token, :string, index: true, unique: true
  end
end
