require_relative 'boot'
require 'rails/all'
require 'pdfkit'

Bundler.require(*Rails.groups)

module Subscribe
  class Application < Rails::Application
    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.autoload_paths += %W(#{config.root}/app/workers)
    config.autoload_paths += %W(#{config.root}/app/services)
    config.autoload_paths += %W(#{config.root}/app/concerns)

    # CUSTOM MIDDLEWARE
    config.middleware.use PDFKit::Middleware

    config.time_zone = 'Nairobi'
    config.exception_handler = {dev: true}
    config.active_job.queue_adapter = :sidekiq
    config.app_generators.scaffold_controller :responders_controller
    config.action_mailer.default_url_options = { host: ENV['host'] }
    # config.middleware.insert_before ActionDispatch::ParamsParser, "CatchJsonParseErrors"
  end
end
