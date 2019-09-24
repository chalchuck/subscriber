class AddReferenceCouponToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_reference :subscriptions, :coupon, foreign_key: true
  end
end
