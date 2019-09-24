# frozen_string_literal: true

class PlansController < BaseController
  before_action :current_plan, only: %i[edit show update destroy]

  def index
    @plans = @current_business.plans.page(params.dig(:page)).per(10)
  end

  def show; end

  def edit; end

  # upgrade
  # downgrade

  def new
    @plan = @current_business.plans.new
  end

  def create
    @plan = @current_business.plans.new(plan_params)
    if @plan.save
      redirect_to [@current_business, :plans], notice: I18n.t('record.success', value: 'plan')
    else
      render :new, alert: I18n.t('record.error')
    end
  end

  def update
    if @current_plan.update(plan_params)
      redirect_to [@current_business, :plans], notice: I18n.t('record.success', value: 'plan')
    else
      render :edit, alert: I18n.t('record.error')
    end
  end

  def destroy
    @current_plan.destroy
    redirect_to [@current_business, :plans], notice: I18n.t('record.destroy')
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :amount, :interval_count, :interval, :description, :start)
  end

  def current_plan
    @current_plan ||= @current_business.plans.find_by_identifier!(params.dig(:id))
  end
end
