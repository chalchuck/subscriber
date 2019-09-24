class NotificationMailer < ApplicationMailer


	def payment_receipt

	end

	def subscription_invoice(invoice)
		@invoice = invoice
		@customer = @invoice.try(:customer)
		@business = @invoice.try(:business)
		@subscription = @invoice.try(:subscription)
		@plan = @subscription.try(:plan)
		@due_date = @invoice.try(:due_date).to_time.in_time_zone.strftime("%d %B, %Y")

		mail(
			to: "info@symatechlabs.com",
			from: 'me@coincycle.co',
			subject: "Invoice #{@invoice.try(:receipt_number)}"
		)
	end
end
