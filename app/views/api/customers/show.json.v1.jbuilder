if @current_customer.present?
	json.partial! 'api/customers/customer', customer: @current_customer
end
