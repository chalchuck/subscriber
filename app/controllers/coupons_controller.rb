# frozen_string_literal: true

class CouponsController < BaseController
  before_action :current_coupon, only: %i[edit show update destroy]

  def index
    @coupons = @current_business
               .coupons.includes(%i[business subscriptions])
               .page(params.dig(:page)).per(10)
  end

  def show; end

  def edit; end

  # upgrade
  # downgrade

  def new
    @coupon = @current_business.coupons.new
  end

  def create
    @coupon = @current_business.coupons.new(coupon_params)
    if @coupon.save
      redirect_to [@current_business, :coupons], notice: I18n.t('record.success', value: 'coupon')
    else
      render :new, alert: I18n.t('record.error')
    end
  end

  def update
    if @current_coupon.update(coupon_params)
      redirect_to [@current_business, :coupons], notice: I18n.t('record.success', value: 'coupon')
    else
      render :edit, alert: I18n.t('record.error')
    end
  end

  def destroy
    @current_coupon.destroy
    redirect_to [@current_business, :coupons], notice: I18n.t('record.destroy')
  end

  private

  def coupon_params
    params.require(:coupon).permit(:amount_off, :percent_off, :currency, :duration, :redeem_by)
  end

  def current_coupon
    @current_coupon ||= @current_business
                        .coupons.includes(%i[business subscriptions])
                        .find_by_identifier!(params.dig(:id))
  end
end
