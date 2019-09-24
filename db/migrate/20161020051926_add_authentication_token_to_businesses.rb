class AddAuthenticationTokenToBusinesses < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :authentication_token, :string, index: true, unique: true
  end
end
