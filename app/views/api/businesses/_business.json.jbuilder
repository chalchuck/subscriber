json.ignore_nil!
json.extract!(
  business,
  :id, :identifier, :name, :email, :phone_number
)
