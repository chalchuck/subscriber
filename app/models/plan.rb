# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  amount         :decimal(10, 3)
#  business_id    :integer
#  created_at     :datetime         not null
#  currency       :string           default("KES")
#  description    :text
#  id             :integer          not null, primary key
#  identifier     :string
#  interval       :string
#  interval_count :integer          default(1)
#  livemode       :boolean
#  name           :string
#  start          :datetime
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_plans_on_business_id  (business_id)
#  index_plans_on_name         (name)
#

# NOTE: start defaults to created_at
# NOTE: currency defaults to KES

class Plan < ApplicationRecord
  has_secure_token :identifier
  INTERVALS = %w[Monthly Yearly].freeze # Daily Weekly

  # ###########VALIDATIONS#######################################################

  validates :name,
            presence: { message: I18n.t('plan.name.req') },
            uniqueness: { message: I18n.t('plan.name.exists'), scope: :business_id }
  validates :amount,
            presence: { message: I18n.t('plan.amount.req') },
            numericality: { message: 'Supply a number' }
  validates :interval_count,
            presence: { message: I18n.t('plan.interval.req') },
            numericality: { message: 'Supply a number' }
  validates :interval, presence: true, inclusion: { in: INTERVALS }

  # ###########ASSOCIATONS#######################################################

  belongs_to :business
  has_many :subscriptions, dependent: :destroy

  # ###########SCOPES############################################################

  default_scope -> { order('created_at DESC') }
  INTERVALS.each { |scopeit| scope scopeit.try(:downcase), -> { where(interval: scopeit.try(:to_s).try(:downcase)) } }

  # ###########CALLBACKS#########################################################

  ##############################################################################

  def to_s
    try(:name).upcase
  end

  def to_param
    try(:identifier)
  end
end
