# frozen_string_literal: true

# == Schema Information
#
# Table name: businesses
#
#  authentication_token :string
#  created_at           :datetime         not null
#  email                :string
#  fantasy_name         :string
#  id                   :integer          not null, primary key
#  identifier           :string
#  name                 :string
#  phone_number         :string
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_businesses_on_email         (email)
#  index_businesses_on_fantasy_name  (fantasy_name)
#  index_businesses_on_identifier    (identifier)
#  index_businesses_on_name          (name)
#  index_businesses_on_phone_number  (phone_number)
#

class Business < ApplicationRecord
  include TokenAuthenticable

  has_secure_token :identifier
  name_regex = /\A[a-zA-Z0-9_-]{2,10}\z/

  # ###########VALIDATIONS#######################################################

  validates :email,
            presence: { message: I18n.t('business.email.req') },
            uniqueness: { message: I18n.t('business.business.email.taken') }
  validates :phone_number,
            presence: { message: I18n.t('business.number.req') },
            uniqueness: { message: I18n.t('business.business.number.taken') }
  validates :fantasy_name,
            presence: { message: I18n.t('business.fantasy_name.req') },
            uniqueness: { message: I18n.t('business.business.fantasy_name.taken') },
            format: { with: name_regex, message: I18n.t('business.fantasy_name.invalid') }
  validates :name, presence: { message: I18n.t('business.name.req') }

  # ###########ASSOCIATONS#######################################################

  has_many :coupons, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships
  has_many :plans, dependent: :destroy
  has_many :customers, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribe_transactions, dependent: :destroy

  # ###########SCOPES############################################################
  # ###########CALLBACKS#########################################################
  ##############################################################################

  def to_s
    try(:name)
  end

  def to_param
    try(:fantasy_name)
  end
end
