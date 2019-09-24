# frozen_string_literal: true

module StatusMessages
  extend ActiveSupport::Concern

  def deny_access
    render status: 401, json: { message: I18n.t('bad_credentials') }
  end

  def invalid_params
    render status: 422, json: { message: I18n.t('invalid_params') }
  end

  def invalid_plan
    render status: 422, json: { message: 'The specified plan is invalid or not present' }
  end

  def invalid_customer
    render status: 422, json: { message: 'The specified customer is invalid or not present' }
  end

  def resource_not_found(e = '')
    message = (e.present? ? "#{e} with ID: #{params.dig(:id)}" : I18n.t('not_found'))
    render status: 404, json: { message: message }
  end
end
