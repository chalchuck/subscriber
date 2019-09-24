class InvoiceJob < ApplicationJob
  queue_as :subscribe

  def perform(invoice)
    if invoice.present?

    end
  end
end
