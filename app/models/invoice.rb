# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  amount_due      :decimal(32, 4)
#  balance         :decimal(64, 6)   default(0.0)
#  business_id     :integer
#  created_at      :datetime         not null
#  currency        :string           default("KES")
#  customer_id     :integer
#  description     :text
#  discount        :decimal(64, 6)
#  due_date        :datetime
#  id              :integer          not null, primary key
#  identifier      :string
#  paid            :decimal(64, 6)   default(0.0)
#  receipt_number  :string
#  relief          :decimal(64, 6)
#  status          :string           default("verynew")
#  subscription_id :integer
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_invoices_on_business_id      (business_id)
#  index_invoices_on_customer_id      (customer_id)
#  index_invoices_on_identifier       (identifier)
#  index_invoices_on_receipt_number   (receipt_number)
#  index_invoices_on_subscription_id  (subscription_id)
#
# Foreign Keys
#
#  fk_rails_0d349e632f  (customer_id => customers.id)
#  fk_rails_457c900f6e  (subscription_id => subscriptions.id)
#  fk_rails_830b37ed59  (business_id => businesses.id)
#

class Invoice < ApplicationRecord
  has_secure_token :identifier

  STATUS = %w[unpaid paid paying pastdue verynew].freeze

  # ###########VALIDATIONS#######################################################

  validates :customer, presence: { message: I18n.t('invoice.customer.req') }
  validates :business, presence: { message: I18n.t('invoice.business.req') }
  validates :subscription, presence: { message: I18n.t('invoice.subscription.req') }

  # ###########ASSOCIATONS#######################################################

  belongs_to :customer
  belongs_to :business
  belongs_to :subscription
  has_many :subscribe_transactions, dependent: :destroy

  # ###########SCOPES############################################################

  default_scope -> { order('created_at DESC') }

  # ###########CALLBACKS#########################################################

  after_commit :make_receipt_number, on: :create
  after_commit :generate_invoice, on: :create
  after_commit :deliver_customer_email, on: :update

  before_validation -> { self[:amount_due] = compute_amount_due }
  before_validation -> { self[:due_date]   = Time.zone.now + 7.days }

  ##############################################################################

  STATUS.each do |iaction|
    define_method "#{iaction}?" do
      status.eql?(iaction.try(:to_s))
    end
  end

  def fully_paid?
    balance.try(:to_f).eql?(0.0) ||
      paid.try(:to_f).eql?(amount_due.try(:to_f)) ||
      (paid.try(:to_f) > amount_due.try(:to_f))
  end

  private

  def generate_invoice
    NotificationMailer.subscription_invoice(self).deliver_later
  end

  def deliver_customer_email; end

  def compute_amount_due
    plan = subscription&.try(:plan)
    plan.try(:amount) * subscription.try(:quantity)
  end

  def make_receipt_number
    loop do
      raw = [('0'..'9'), ('A'..'Z')].map(&:to_a).flatten
      enc = (0..7).map { raw[rand(raw.length)] }.join.try(:upcase)
      update(receipt_number: enc) unless receipt_number.present?
      break enc unless Invoice.find_by_receipt_number(enc)
    end
  end
end
