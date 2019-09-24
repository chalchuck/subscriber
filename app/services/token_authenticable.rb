# frozen_string_literal: true

module TokenAuthenticable
  extend ActiveSupport::Concern

  included do
    private :make_authentication_token
    before_save :assign_authentication_token
  end

  def assign_authentication_token
    if authentication_token.blank?
      self.authentication_token = make_authentication_token
    end
  end

  def make_authentication_token
    BCrypt::Password.create(Time.now.in_time_zone('UTC').strftime('%Y%m%d%H%M%S'), cost: 11)
  end
end
