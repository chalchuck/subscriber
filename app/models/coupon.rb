# frozen_string_literal: true

# == Schema Information
#
# Table name: coupons
#
#  active         :boolean          default(TRUE)
#  amount_off     :decimal(64, 6)
#  business_id    :integer
#  created_at     :datetime         not null
#  currency       :string           default("KES")
#  duration       :string
#  id             :integer          not null, primary key
#  identifier     :string
#  metadata       :jsonb
#  percent_off    :decimal(64, 6)
#  redeem_by      :datetime
#  times_redeemed :integer          default(0)
#  updated_at     :datetime         not null
#  user_id        :integer
#
# Indexes
#
#  index_coupons_on_business_id  (business_id)
#  index_coupons_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_69b54b3afe  (user_id => users.id)
#  fk_rails_7fe396e225  (business_id => businesses.id)
#

class Coupon < ApplicationRecord
  has_secure_token :identifier
  DURATION = %w[once forever].freeze # TODO: repeating v1

  # ###########VALIDATIONS#######################################################

  validate :ensure_only_amount_or_percent
  validates :business, presence: { message: I18n.t('coupon.business.req') }
  validates :percent_off, presence: { message: I18n.t('coupon.percent_off.req') }, if: -> { amount_off.blank? }
  validates :amount_off, presence: { message: I18n.t('coupon.amount_off.req') },   if: -> { percent_off.blank? }
  validates :duration, presence: { message: I18n.t('coupon.duration.req') },
                       inclusion: { in: DURATION, message: I18n.t('coupon.duration.invalid') },
                       uniqueness: { scope: %i[amount_off percent_off], message: I18n.t('coupon.duration.exists') }

  # ###########ASSOCIATONS#######################################################

  belongs_to :user
  belongs_to :business
  has_many :subscriptions

  # ###########SCOPES############################################################

  default_scope -> { order('created_at DESC') }

  DURATION.each { |sc| scope sc, -> { where(duration: sc.try(:to_s)) } }

  # ###########CALLBACKS#########################################################

  before_validation -> { self[:duration] = duration.try(:downcase) }

  ##############################################################################

  def to_param
    try(:identifier)
  end

  DURATION.each do |method|
    define_method "#{method}?" do
      duration.eql?(method.try(:to_s))
    end
  end

  %i[percent_off amount_off].each do |method|
    define_method "#{method}?" do
      send(method).present?
    end
  end

  private

  def ensure_only_amount_or_percent
    errors.add(:amount_off, I18n.t('coupon.only_one')) if amount_off.present? && percent_off.present?
  end
end
