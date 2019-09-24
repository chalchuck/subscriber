# frozen_string_literal: true

class PaymentCallbacksController < ApplicationController
  include AuthenticateTransactions

  protect_from_forgery with: :null_session
  # before_action :authenticate_c2b_callback!, only: :ipn

  def ipn
    PaymentProcessingJob.perform_now(clean_params)
    render status: 200,
           json: {
             message: 'Transaction processing successful',
             delivery_hash: request.env['HTTP_X_ORTA_DELIVERY'],
             delivery_signature: request.env['HTTP_X_HUB_SIGNATURE']
           }
  end

  private

  def clean_params
    params.permit([*attrs]).to_h
  end

  def attrs
    [
      :bill_ref_number, :trans_id, :msisdn,
      :sender,
      :trans_time, :trans_amount, :actual_amount,
      charges: [
        :amount_in_cents, :commission, :amount, :charge_type, tariff: %i[name percent]
      ]
    ]
  end
end
