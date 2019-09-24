if @current_subscription.present?
  json.ignore_nil!
  json.extract!(@current_subscription, :status)
end
