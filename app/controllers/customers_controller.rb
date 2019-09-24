# frozen_string_literal: true

class CustomersController < BaseController
  before_action :current_customer, only: %i[edit update show]

  def index
    @customers = @current_business.customers.page(params.dig(:page)).per(10)
  end

  def transactions
    @transactions = @current_customer.try(:subscribe_transactions).page(params.dig(:page))
  end

  def show; end

  def edit; end

  def new
    @customer = @current_business.customers.new
  end

  def create
    @customer = @current_business.customers.new(customer_params)
    if @customer.save
      redirect_to [@current_business, :customers], notice: I18n.t('record.success', value: 'plan')
    else
      render :new, alert: I18n.t('record.error')
    end
  end

  def update
    if @current_customer.update(customer_params)
      redirect_to [@current_business, :customers], notice: I18n.t('record.success', value: 'plan')
    else
      render :edit, alert: I18n.t('record.error')
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :mobile_number)
  end

  def current_customer
    @current_customer ||= @current_business.customers.find_by_identifier!(params.dig(:id))
  rescue ActiveRecord::RecordNotFound
  end
end
