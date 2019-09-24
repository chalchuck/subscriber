class AddStatusToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    remove_column :subscriptions, :status, :string
    add_column :subscriptions, :status, :string, default: "new"
  end
end
