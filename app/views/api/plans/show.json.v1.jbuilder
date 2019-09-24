if @current_plan.present?
	json.partial! 'api/plans/plan', plan: @current_plan
end
