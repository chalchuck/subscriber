# frozen_string_literal: true

module Gateway
  module IPN
    class Callback
      attr_reader :params, :struct

      def initialize(params)
        @params = params
        @struct = OpenStruct.new(params)
      end

      def perform
        if current_invoice.present?
          SubscribeTransaction.create!(trans_params)
          current_invoice.increment!(:paid, params&.dig('actual_amount').try(:to_f))
          update_invoice_balance
        end
      end

      private

      def update_invoice_balance
        current_invoice.update!(balance: balance)
        update_invoice_status
      rescue ActiveRecord::RecordInvalid => e
        ExceptionNotifier.notify_exception(
          e, data: { class: 'Gateway::IPN::Callback', method: 'update_invoice_balance' }
        )
      end

      # paying, paid, unpaid
      def update_invoice_status
        current_invoice.update!(status: 'paid') if current_invoice.fully_paid?
        current_invoice.update!(status: 'paying') unless current_invoice.fully_paid?
      end

      def balance
        current_invoice.try(:amount_due) - current_invoice.try(:paid)
      end

      def trans_params
        params
          .except('charges', 'kyc_info').merge(
            origin: 'MPESA', raw_transaction: params, invoice: current_invoice,
            business: current_invoice.try(:business), customer: current_invoice.try(:customer),
            subscription: current_invoice.try(:subscription)
          )
        # TODO: Handle cases where invoice is absent
      end

      def current_invoice
        query_str = invoice_receipt.try(:upcase)
        @current_invoice ||= Invoice.find_by_receipt_number!(query_str)
      rescue ActiveRecord::RecordNotFound => e
        ExceptionNotifier.notify_exception(e,
          data: { class: 'Gateway::IPN::Callback', method: 'current_invoice'}
        )
      end

      def invoice_receipt
        return '' unless struct.try(:bill_ref_number).present?

        ref = struct.try(:bill_ref_number).split(/[-!@#$%^&.*()+=?:;]/)
        ref.delete_if(&:blank?).last.try(:strip)
      end
    end
  end
end
