# frozen_string_literal: true

module AuthenticationHelpers
  extend ActiveSupport::Concern

  private

  def authenticate_api!
    return deny_access unless authenticate_api
  end

  def authenticate_api
    API::Authenticate::Core.new(auth_params).allow_access?
  end

  def current_user
    @current_user ||= API::Authenticate::Core.new(auth_params).current_user
  end

  def current_business
    @current_business ||= API::Authenticate::Core.new(auth_params).current_business
  end

  def auth_params
    OpenStruct.new(
      user: user, token: pass, business_token: business_secret, business_secret: business_token
    )
  end

  def user
    request.env['HTTP_USER'].present? ? request.env['HTTP_USER'] : params.dig(:user)
  end

  def pass
    request.env['HTTP_PASS'].present? ? request.env['HTTP_PASS'] : params.dig(:pass)
  end

  def business_secret
    request.env['HTTP_BUSINESS_TOKEN'].present? ? request.env['HTTP_BUSINESS_TOKEN'] : params.dig(:business_token)
  end

  def business_token
    request.env['HTTP_BUSINESS_SECRET'].present? ? request.env['HTTP_BUSINESS_SECRET'] : params.dig(:business_secret)
  end
end
