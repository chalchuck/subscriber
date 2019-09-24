VersionCake.setup do |config|

  config.resources do |r|
    r.resource %r{.*}, [], [], (1..9)
  end

  config.missing_version = 1

  config.version_key           = 'api_version'
  config.rails_view_versioning = true
  # config.response_strategy     = [:http_content_type, :http_header]
  config.extraction_strategy   = [:http_accept_parameter, :http_header, :request_parameter, :path_parameter, :query_parameter]
end
