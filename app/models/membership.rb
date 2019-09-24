# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  business_id :integer
#  created_at  :datetime         not null
#  id          :integer          not null, primary key
#  updated_at  :datetime         not null
#  user_id     :integer
#
# Indexes
#
#  index_memberships_on_business_id  (business_id)
#  index_memberships_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_99326fb65d  (user_id => users.id)
#  fk_rails_a5acc905ee  (business_id => businesses.id)
#

class Membership < ApplicationRecord
  # ###########VALIDATIONS#######################################################

  validates :user, :business, presence: true
  validates :business, uniqueness: { scope: :user_id }

  # ###########ASSOCIATONS#######################################################

  belongs_to :user
  belongs_to :business

  # ###########SCOPES############################################################
  # ###########CALLBACKS#########################################################
end
