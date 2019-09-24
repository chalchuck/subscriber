if @subscriptions.present?
	json.array! @subscriptions, partial: 'api/subscriptions/subscription', as: :subscription
end
