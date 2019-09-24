# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  business_id   :integer
#  created_at    :datetime         not null
#  currency      :string
#  description   :text
#  email         :string
#  id            :integer          not null, primary key
#  identifier    :string
#  mobile_number :string
#  name          :string
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_customers_on_business_id    (business_id)
#  index_customers_on_email          (email)
#  index_customers_on_mobile_number  (mobile_number)
#  index_customers_on_name           (name)
#
# Foreign Keys
#
#  fk_rails_b73113df4b  (business_id => businesses.id)
#

class Customer < ApplicationRecord
  has_secure_token :identifier

  # ###########VALIDATIONS#######################################################

  validates :email, email: true,
                    presence: { message: I18n.t('email.blank') },
                    uniqueness: { message: I18n.t('email.exists') }
  validates :name,
            presence: { message: I18n.t('customer.name.blank') }
  validates :mobile_number,
            presence: { message: I18n.t('customer.number.blank') },
            uniqueness: { message: I18n.t('customer.number.exists') }

  # ###########ASSOCIATONS#######################################################

  belongs_to :business
  has_many :invoice, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribe_transactions, dependent: :destroy

  # ###########SCOPES############################################################

  default_scope -> { order('created_at DESC') }

  # ###########CALLBACKS#########################################################

  before_validation -> {
    self[:mobile_number] = PhonyRails.normalize_number(self[:mobile_number], country_code: 'KE')
  }

  ##############################################################################

  def to_param
    try(:identifier)
  end

  def to_s
    try(:name).upcase
  end
end
