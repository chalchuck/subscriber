# frozen_string_literal: true

module AuthenticateTransactions
  extend ActiveSupport::Concern

  def authenticate_c2b_callback!
    verify_signature?
  end

  def verify_signature?
    rack_utils.present? ? true : invalid_signature!
  end

  def signature
    'sha1=' + encrypted_signature(ENV['XTOKEN'])
  end

  def rack_utils
    Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end

  def invalid_signature!
    render status: 401, json: { message: 'Authentication signatures did not match' }
  end

  def encrypted_signature(token)
    decry_params = params.as_json.except('action', 'controller')
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), token, JSON(decry_params))
  end
end
