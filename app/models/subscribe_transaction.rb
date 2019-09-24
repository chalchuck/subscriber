# frozen_string_literal: true

# == Schema Information
#
# Table name: subscribe_transactions
#
#  actual_amount   :decimal(64, 5)
#  bill_ref_number :string
#  business_id     :integer
#  created_at      :datetime         not null
#  customer_id     :integer
#  id              :integer          not null, primary key
#  identifier      :string
#  invoice_id      :integer
#  msisdn          :string
#  origin          :string
#  raw_transaction :jsonb
#  sender          :string
#  subscription_id :integer
#  trans_amount    :decimal(64, 5)
#  trans_id        :string
#  trans_time      :datetime
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_subscribe_transactions_on_bill_ref_number  (bill_ref_number)
#  index_subscribe_transactions_on_business_id      (business_id)
#  index_subscribe_transactions_on_customer_id      (customer_id)
#  index_subscribe_transactions_on_invoice_id       (invoice_id)
#  index_subscribe_transactions_on_msisdn           (msisdn)
#  index_subscribe_transactions_on_sender           (sender)
#  index_subscribe_transactions_on_subscription_id  (subscription_id)
#  index_subscribe_transactions_on_trans_id         (trans_id)
#
# Foreign Keys
#
#  fk_rails_21fbc5a255  (customer_id => customers.id)
#  fk_rails_504c2c6cae  (invoice_id => invoices.id)
#  fk_rails_b824266133  (subscription_id => subscriptions.id)
#  fk_rails_fe278236d7  (business_id => businesses.id)
#

class SubscribeTransaction < ApplicationRecord
  has_secure_token :identifier

  # STATES = %w{success suspended reconciled}
  attr_readonly :trans_id, :msisdn, :trans_time, :bill_ref_number, :trans_amount

  # ###########VALIDATIONS#######################################################

  # validates :status, inclusion: {in: STATES}
  validates :trans_id, presence: true, uniqueness: { case_sensitive: false }
  validates :msisdn, :trans_time, :trans_amount, presence: true

  # ###########ASSOCIATONS#######################################################

  belongs_to :business
  belongs_to :customer
  belongs_to :invoice
  belongs_to :subscription

  # ###########SCOPES############################################################

  default_scope -> { order('created_at DESC') }
  # STATES.each { |sc| scope sc, ->{ where(status: sc.try(:to_s)) }}

  # ###########CALLBACKS#########################################################

  after_commit :make_receipt, on: :create

  ##############################################################################

  private

  def make_receipt
    ReceiptWorker.perform_in(2.seconds, identifier)
  end
end
