# frozen_string_literal: true

module SubscriptionHelpers
  extend ActiveSupport::Concern

  included do
    before_action :plan_params, only: :create
    before_action :customer_params, only: :create
    before_action :validate_params, only: :create
    before_action :subscription_plan, only: :create
    before_action :subscription_customer, only: :create
    before_action :subscription_coupon, only: :create
  end

  private

  def validate_params
    return invalid_params if params.dig(:subscription).blank?
  end

  def plan_params
    return invalid_plan if params.dig(:subscription, :plan).blank?
  end

  def customer_params
    return invalid_customer if params.dig(:subscription, :customer).blank?
  end

  # TODO: Combine the finders into one awesome metaprrogrammed magnititude

  def subscription_coupon
    @current_coupon ||=
      @current_business
      .coupons
      .find_by_identifier!(params.dig(:subscription, :coupon))
  rescue ActiveRecord::RecordNotFound
    invalid_coupon
  end

  def subscription_plan
    @current_plan ||=
      @current_business
      .plans
      .find_by_identifier!(params.dig(:subscription, :plan))
  rescue ActiveRecord::RecordNotFound
    invalid_plan
  end

  def subscription_customer
    @current_customer ||=
      @current_business
      .customers
      .find_by_identifier!(params.dig(:subscription, :customer))
  rescue ActiveRecord::RecordNotFound
    invalid_customer
  end
end
