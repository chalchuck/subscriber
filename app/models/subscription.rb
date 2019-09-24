# frozen_string_literal: true

# == Schema Information
#
# Table name: subscriptions
#
#  business_id :integer
#  coupon_id   :integer
#  created_at  :datetime         not null
#  customer_id :integer
#  id          :integer          not null, primary key
#  identifier  :string
#  plan_id     :integer
#  quantity    :integer          default(1)
#  start       :datetime
#  status      :string           default("inactive")
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_business_id  (business_id)
#  index_subscriptions_on_coupon_id    (coupon_id)
#  index_subscriptions_on_customer_id  (customer_id)
#  index_subscriptions_on_plan_id      (plan_id)
#
# Foreign Keys
#
#  fk_rails_63d3df128b  (plan_id => plans.id)
#  fk_rails_66eb6b32c1  (customer_id => customers.id)
#  fk_rails_cc26b49d37  (coupon_id => coupons.id)
#  fk_rails_e8338852a3  (business_id => businesses.id)
#

class Subscription < ApplicationRecord
  has_secure_token :identifier
  # attr_readonly :start, :plan, :customer
  STATUSES = %w[inactive active unpaid canceled pastdue].freeze

  # ###########VALIDATIONS#######################################################

  validates :plan,
            presence: { message: I18n.t('subs.plan.absent') }
  validates :quantity,
            presence: { message: I18n.t('subs.qty.absent') },
            numericality: { message: 'Should be a whole number', only_integer: true }
  validates :customer,
            presence: { message: I18n.t('subs.customer.absent') }
  # validates :customer,
  # uniqueness: {
  # scope: [:plan_id, :business_id], message: I18n.t('subs.customer.active')}
  validates :status, inclusion: { in: STATUSES }

  # ###########ASSOCIATONS#######################################################

  belongs_to :plan
  belongs_to :customer
  belongs_to :business
  belongs_to :coupon
  has_many :invoices, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :subscribe_transactions, dependent: :destroy

  # ###########SCOPES############################################################

  default_scope -> { order('created_at DESC') }
  STATUSES.each { |sc| scope sc, -> { where(status: sc.try(:to_s)) } }

  # ###########CALLBACKS#########################################################

  after_commit :set_start_date, on: :create, if: -> { start.blank? }
  after_commit :schedule_for_activation, on: :create, if: -> { start.present? }

  ##############################################################################

  def to_param
    try(:identifier)
  end

  STATUSES.each do |smethod|
    define_method "#{smethod}?" do
      status.eql?(smethod.try(:to_s))
    end
  end

  private

  def set_start_date
    update(start: Time.zone.now, status: 'active')
    SchedulesJob.set(wait: 1.second).perform_later(self)
  end

  def schedule_for_activation
    SubscriptionActivationJob.set(wait_until: start).perform_later(self)
  end

  # TODO: Ensure that:
  # start, plan, customer cannot be changed/updated by whatever reason
end
