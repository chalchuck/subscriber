class AddPlanToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_reference :subscriptions, :plan, foreign_key: true
    add_reference :subscriptions, :customer, foreign_key: true
  end
end
