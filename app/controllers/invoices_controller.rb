# frozen_string_literal: true

class InvoicesController < BaseController
  before_action :current_invoice, only: :show

  def index
    @invoices = @current_business.invoices.includes(%i[customer subscription]).page(params.dig(:page)).per(10)
  end

  def transactions
    @transactions = @current_invoice.try(:subscribe_transactions).page(params.dig(:page))
  end

  def show; end

  private

  def current_invoice
    @current_invoice ||= @current_business.invoices.find_by_receipt_number!(params.dig(:id))
  end

  # TODO: generate PDF
  # TODO: Resend to customer
  # TODO:
end
