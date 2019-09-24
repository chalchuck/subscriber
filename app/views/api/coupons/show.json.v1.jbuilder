if @current_coupon.present?
	json.partial! 'api/coupons/coupon', coupon: @current_coupon
end
