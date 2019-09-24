json.ignore_nil!
json.extract!(
  coupon,
  :id, :identifier,
  :amount_off, :percent_off, :currency,
  :duration, :metadata, :redeem_by, :times_redeemed, :active
)

json.business do
  json.partial! 'api/businesses/business', business: coupon.try(:business)
end

# json.subscription do
#   json.partial! 'api/subscriptions/subscription', subscription: coupon.try(:subscription)
# end
