# frozen_string_literal: true

class BusinessesController < BaseController
  skip_before_action :default_business, only: %i[new create]
  before_action :find_business, only: %i[transactions show edit update destroy]

  def index
    @businesses = current_user.businesses.page(params.dig(:page)) # .per(10)
  end

  def transactions
    @transactions = @current_business.try(:subscribe_transactions)
                                     .includes([:subscription]).page(params.dig(:page)).per(10)
  end

  def show; end

  def edit; end

  def new
    @business = Business.new
  end

  def create
    @business = Business.new(business_params)
    if @business.save
      # JoinMemberJob.perform_later(@business, current_user)
      redirect_to @business, notice: I18n.t('record.success', value: 'business')
      Membership.create(user: current_user, business: @business)
    else
      render :new, alert: I18n.t('record.error')
    end
  end

  def update
    if @current_business.update(business_params)
      redirect_to @current_business, notice: I18n.t('record.success', value: 'business')
    else
      render :edit, alert: I18n.t('record.error')
    end
  end

  def destroy
    @current_business.destroy
    redirect_to businesses_url, notice: I18n.t('record.destroy')
  end

  private

  def business_params
    params.require(:business).permit(:email, :phone_number, :fantasy_name, :name)
  end

  def find_business
    @current_business ||=
      current_user.businesses.find_by_fantasy_name!(params.dig(:id))
  end
end
