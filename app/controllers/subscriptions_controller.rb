# frozen_string_literal: true

class SubscriptionsController < BaseController
  before_action :current_subscription, only: %i[show edit update]

  def index
    @subscriptions = @current_business.subscriptions.includes(%i[plan customer]).page(params.dig(:page)).per(25)
  end

  def transactions
    @transactions = @current_subscription.try(:subscribe_transactions).page(params.dig(:page))
  end

  def show; end

  def edit; end

  def new
    @subscription = @current_business.subscriptions.new
  end

  def create
    @subscription = @current_business.subscriptions.new(subs_params)
    if @subscription.save
      redirect_to [@current_business, :subscriptions], notice: I18n.t('record.success', value: 'subscription')
    else
      render :new, alert: I18n.t('record.error')
    end
  end

  def update
    if @current_subscription.update(update_params)
      redirect_to [@current_business, :subscriptions], notice: I18n.t('record.success', value: 'subscriptions')
    else
      render :edit, alert: I18n.t('record.error')
    end
  end

  private

  def update_params
    params.require(:subscription).permit(:quantity)
  end

  def subs_params
    params.require(:subscription).permit(:start, :quantity, :plan_id, :customer_id)
  end

  def current_subscription
    @current_subscription ||= @current_business.subscriptions.find_by_identifier!(params.dig(:id))
  end
end
