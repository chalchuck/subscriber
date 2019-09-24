# frozen_string_literal: true

module API
  class CustomersController < CoreController
    before_action :validate_params, only: [:create]
    before_action :current_customer, only: [:show]

    def index
      @customers = @current_business.customers.includes(:business)
                                    .page(params.dig(:page)).per(25)
    end

    def show; end

    def create
      @current_customer = @current_business.customers.create(customer_params)
      respond_with :api, @current_customer
    end

    # TODO: delete
    # TODO: update
    # TODO: pagination

    private

    def validate_params
      return invalid_params if params.dig(:customer).blank?
    end

    def customer_params
      params.require(:customer).permit(:name, :email, :mobile_number)
    end

    def current_customer
      @current_customer ||= @current_business.customers.includes(:business).find_by_identifier!(params.dig(:id))
    rescue ActiveRecord::RecordNotFound => e
      resource_not_found(e)
    end
  end
end
