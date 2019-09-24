# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  created_at          :datetime         not null
#  id                  :integer          not null, primary key
#  identifier          :string
#  metadata            :jsonb
#  recurrence_interval :string
#  rety_count          :integer          default(0)
#  scheduled_at        :datetime
#  status              :string           default("inactive")
#  subscription_id     :integer
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_schedules_on_identifier       (identifier)
#  index_schedules_on_subscription_id  (subscription_id)
#
# Foreign Keys
#
#  fk_rails_b2b9b40998  (subscription_id => subscriptions.id)
#

class Schedule < ApplicationRecord
  has_secure_token :identifier

  STATUSES = %w[inactive retried processed processing queued failed rescheduled].freeze

  # ###########VALIDATIONS#######################################################

  validates :status, inclusion: { in: STATUSES }
  validates :subscription, presence: { message: I18n.t('schedules.subs.req') }
  validates :scheduled_at, presence: { message: I18n.t('schedules.scheduled.req') }
  validates :recurrence_interval, presence: { message: I18n.t('schedules.recurrence_interval.req') }

  # ###########ASSOCIATONS#######################################################

  belongs_to :subscription

  # ###########SCOPES############################################################

  default_scope -> { order('created_at DESC') }
  STATUSES.each { |sc| scope sc, -> { where(status: sc.try(:to_s)) } }

  # ###########CALLBACKS#########################################################

  after_commit :invoice_customer,
               on: :create,
               if: -> { subscription.active? && sheduled_for_today? }

  ##############################################################################

  STATUSES.each do |method|
    define_method "#{method}?" do
      status.eql?(method.try(:to_s))
    end
  end

  private

  def sheduled_for_today?
    (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).cover?(scheduled_at)
  end

  def invoice_customer
    InvoiceWorker.perform_in(1.second, try(:identifier))
  end
end
