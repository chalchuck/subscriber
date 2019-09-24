json.ignore_nil!
json.extract!(
  plan,
  :id, :name, :amount, :interval,
  :livemode, :start, :currency, :interval_count, :identifier
)

# json.business do
#   json.partial! 'api/businesses/business', business: plan.business
# end
