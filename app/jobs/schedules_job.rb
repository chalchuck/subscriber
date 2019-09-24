class SchedulesJob < ApplicationJob
  queue_as :subscribe

  def perform(subscription)
    if (subscription.present? and subscription.active?)
      begin
          subscription.
          schedules.
          create!(
            scheduled_at: subscription.try(:start),
            recurrence_interval: subscription.try(:plan).try(:interval)
          )
        rescue ActiveRecord::RecordInvalid
          # TODO: Rollbar EVENT
      end
    end
  end
end
