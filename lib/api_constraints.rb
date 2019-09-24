class ApiConstraints

	def initialize(options)
	  @version, @default = options.dig(:version), options.dig(:default)
	end

	def matches?(req)
		@default || req.headers['Accept'].include?("application/vnd.example.v#{@version}")
	end
end
