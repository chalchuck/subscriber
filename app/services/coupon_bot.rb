# frozen_string_literal: true

class CouponBot
  attr_reader :schedule, :coupon, :subscription, :invoice

  def initialize(schedule, invoice)
    @schedule     = schedule
    @invoice      = invoice
    @subscription = schedule&.try(:subscription)
    @coupon       = subscription&.try(:coupon)
  end

  # def perform
  #   apply_coupon if coupon.forever?
  # end
  #
  # def redeem_once
  #   apply_coupon if coupon.try(:times_redeemed).eql?(0)
  # end

  # TODO: URGENT ONE TIME COUPONS

  def perform
    invoice.update!(discount: discount, relief: (invoice.try(:amount_due) - discount))
    coupon.increment!(:times_redeemed, 1)
  end

  def discount
    if coupon.amount_off?
      coupon.try(:amount_off).to_f
    else
      invoice.try(:amount_due) * (coupon.try(:percent_off).to_f / 100)
    end
  end
end
