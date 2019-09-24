class JoinMemberJob < ApplicationJob
  queue_as :subscribe

  def perform(business, user)
    if business.present? and user.present?
      Membership.create(user: user, business: business)
    end
  end
end
