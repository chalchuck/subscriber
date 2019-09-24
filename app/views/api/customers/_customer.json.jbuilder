json.ignore_nil!
json.extract!(
  customer,
  :id, :name, :email, :mobile_number, :identifier
)

# json.business do
#   json.partial! 'api/businesses/business', business: customer.business
# end
