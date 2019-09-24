# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  authentication_token   :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string
#  id                     :integer          not null, primary key
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  mobile_number          :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  updated_at             :datetime         not null
#  username               :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ApplicationRecord
  include Users::DeviseUser
  include TokenAuthenticable

  attr_accessor :name

  # ###########VALIDATIONS#######################################################

  # ###########ASSOCIATONS#######################################################

  has_many :coupons # , dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :businesses, through: :memberships

  # ###########SCOPES############################################################

  # ###########CALLBACKS#########################################################

  before_save

  ##############################################################################

  def to_s
    name
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  def name=(raw)
    self.first_name, *temp = *raw.split(' ')
    self.last_name = temp * ' '
  end

  private

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private_class_method def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      sql = %{lower(username) = :value OR lower(email) = :value}
      where(conditions).where([sql, { value: login&.try(:downcase) }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions).first
    end
  end
end
