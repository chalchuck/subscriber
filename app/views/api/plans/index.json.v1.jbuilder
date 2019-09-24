if @plans.present?
	json.array! @plans, partial: 'api/plans/plan', as: :plan
end
