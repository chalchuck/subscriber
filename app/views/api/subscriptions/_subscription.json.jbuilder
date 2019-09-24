json.ignore_nil!
json.extract!(
  subscription,
  :id, :quantity, :status, :identifier, :start, :created_at, :updated_at
)

json.plan do
  json.partial! 'api/plans/plan', plan: subscription.plan
end

json.customer do
  json.partial! 'api/customers/customer', customer: subscription.customer
end
