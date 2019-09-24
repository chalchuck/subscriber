if @customers.present?
	json.array! @customers, partial: 'api/customers/customer', as: :customer
end
