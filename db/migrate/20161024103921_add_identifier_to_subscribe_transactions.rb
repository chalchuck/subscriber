class AddIdentifierToSubscribeTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscribe_transactions, :identifier, :string, index: true, unique: true
  end
end
