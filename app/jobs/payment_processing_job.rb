class PaymentProcessingJob < ApplicationJob
  queue_as :default

  def perform(params)
    Gateway::IPN::Callback.new(params).perform
  end
end
