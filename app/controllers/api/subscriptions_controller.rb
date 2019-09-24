# frozen_string_literal: true

module API
  class SubscriptionsController < CoreController
    include SubscriptionHelpers

    before_action :current_subscription, only: %i[show status update]

    def show; end

    def status; end

    def index
      @subscriptions = @current_business
                         .subscriptions
                         .includes(%i[plan customer business])
                         .page(params.dig(:page)).per(15)
    end

    def create
      @current_subscription ||= @current_business.subscriptions.create(subscription_params)
      respond_with :api, @current_subscription
    end

    private

    def subscription_params
      params.require(:subscription).permit(:start, :quantity).merge(plan: @current_plan, customer: @current_customer)
    end

    def current_subscription
      @current_subscription ||= @current_business
                                .subscriptions
                                .includes(%i[plan customer business])
                                .find_by_identifier!(params.dig(:id))
    rescue ActiveRecord::RecordNotFound => e
      resource_not_found(e)
    end
  end
end
