# frozen_string_literal: true

module API
  module Authenticate
    class Core
      attr_reader :user, :token, :business_token, :business_secret

      def initialize(params)
        @user  = params&.dig(:user)
        @token = params&.dig(:token)
        @business_token = params&.dig(:business_token)
        @business_secret = params&.dig(:business_secret)
      end

      def allow_access?
        current_user.present? && current_business.present?
      end

      def current_user
        sql = %{lower(email) = :email AND authentication_token = :token}
        @current_user ||= User.where(sql, email: user.try(:downcase), token: token).first
      end

      def current_business
        sql = %(identifier = :identifier AND authentication_token = :secret)
        @current_business ||= current_user.businesses.where(sql, identifier: business_token, secret: business_secret).first
      end
    end
  end
end
