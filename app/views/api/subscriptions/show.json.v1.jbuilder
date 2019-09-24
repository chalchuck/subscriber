if @current_subscription.present?
	json.partial! 'api/subscriptions/subscription', subscription: @current_subscription
end
