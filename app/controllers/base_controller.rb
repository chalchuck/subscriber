# frozen_string_literal: true

class BaseController < ApplicationController
  include StatusMessages

  before_action :authenticate_user!
  before_action :current_business
  before_action :default_business

  def current_business
    if current_user.present?
      @current_business ||= current_user.businesses.try(:last)
    end
  end

  def default_business
    if current_user.present? && @current_business.blank?
      redirect_to %i[new business], notice: I18n.t('business.intro')
    end
  end
end
