if @coupons.present?
	json.array! @coupons, partial: 'api/coupons/coupon', as: :coupon
end
