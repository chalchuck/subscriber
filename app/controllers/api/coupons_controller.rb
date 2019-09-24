# frozen_string_literal: true

module API
  class CouponsController < CoreController
    before_action :validate_params, only: [:create]
    before_action :current_coupon, only: [:show]

    def index
      @coupons = @current_business.coupons.includes(%i[business subscription])
                                  .page(params.dig(:page)).per(25)
    end

    def show; end

    def create
      @current_coupon = @current_business.coupons.create(coupons_params)
      respond_with :api, @current_coupon
    end

    # TODO: DELETE
    # TODO: UPDATE
    # TODO: PAGINATION

    private

    def validate_params
      return invalid_params if params.dig(:coupon).blank?
    end

    def coupons_params
      params
        .require(:coupon)
        .permit(:amount_off, :percent_off, :currency, :duration, :redeem_by)
    end

    def current_coupon
      @current_coupon ||= @current_business
                          .coupons.includes(%i[business subscription])
                          .find_by_identifier!(params.dig(:id))
    rescue ActiveRecord::RecordNotFound => e
      resource_not_found(e)
    end
  end
end
