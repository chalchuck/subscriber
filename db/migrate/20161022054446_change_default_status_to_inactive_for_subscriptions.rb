class ChangeDefaultStatusToInactiveForSubscriptions < ActiveRecord::Migration[5.0]
  def change
    change_column :subscriptions, :status, :string, default: "inactive"
  end
end
