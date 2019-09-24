class SubscriptionActivationJob < ApplicationJob
  queue_as :subscribe

  def perform(subscription)
    if (subscription.present? && subscription.inactive?)
      subscription.update(status: "active")
      SchedulesJob.set(wait: 2.seconds).perform_later(subscription)
    end
  end
end
