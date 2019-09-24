class DefaultSubscriptionQuntityToOne < ActiveRecord::Migration[5.0]
  def change
    change_column :subscriptions, :quantity, :integer, default: 1
  end
end
