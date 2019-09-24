# frozen_string_literal: true

class InvoiceWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :invoice, backtrace: true)

  def perform(schedule_id)
    if schedule_id.present?
      schedule = Schedule.includes(:subscription).find_by_identifier!(schedule_id)
      create_invoice_for_user(schedule)
    end
  end

  def create_invoice_for_user(schedule)
    if schedule.try(:subscription).present?
      begin
        invoice = schedule.try(:subscription).invoices.create!(invoice_params(schedule))
        CouponBot.new(schedule, invoice).perform if schedule.try(:subscription).try(:coupon).present?
      rescue ActiveRecord::RecordInvalid => e
        ExceptionNotifier.notify_exception(e,
          data: {worker: 'InvoiceWorker', queue: 'invoice'}
        )
      end
    end
  end

  def invoice_params(schedule)
    if schedule.present?
      @subscription ||= schedule.try(:subscription)
      @plan         ||= @subscription.try(:plan)

      {
        currency: @plan.try(:currency),
        subscription: @subscription,
        customer: @subscription.try(:customer),
        business: @subscription.try(:business)
      }
    end
  end
end

# ExceptionNotifier.notify_exception(exception,
# :data => {:worker => worker.to_s, :queue => queue, :payload => payload})
