# frozen_string_literal: true

class ReceiptWorker
  include Sidekiq::Worker
  sidekiq_options(queue: :subscribe)

  def perform(identifier)
    if identifier.present?
      transaction = transaction(identifier)
      generate_receipt(transaction) if transaction.present?
    end
  end

  def transaction(identifier)
    @transaction ||= SubscribeTransaction.find_by_identifier!(identifier)
  rescue ActiveRecord::RecordNotFound
  end
end
