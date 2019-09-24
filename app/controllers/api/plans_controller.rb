# frozen_string_literal: true

module API
  class PlansController < CoreController
    before_action :validate_params, only: [:create]
    before_action :current_plan, only: [:show]

    def index
      @plans = @current_business.plans.includes(:business)
                                .page(params.dig(:page)).per(25)
    end

    def show; end

    def create
      @current_plan = @current_business.plans.create(plans_params)
      respond_with :api, @current_plan
    end

    # TODO: delete
    # TODO: update
    # TODO: upgrade
    # TODO: downgrade
    # TODO: pagination

    private

    def validate_params
      return invalid_params if params.dig(:plan).blank?
    end

    def plans_params
      params
        .require(:plan)
        .permit(
          :name, :amount, :currency, :interval_count, :interval, :description, :start
        )
    end

    def current_plan
      @current_plan ||= @current_business.plans.includes(:business)
                                         .find_by_identifier!(params.dig(:id))
    rescue ActiveRecord::RecordNotFound => e
      resource_not_found(e)
    end
  end
end
