Rails.application.configure do

  config.action_mailer.smtp_settings = {
    enable_starttls_auto: true,
    authentication: :plain,
    port: 587,
    domain:    ENV['host'],
    user_name: ENV["sendgrid_user"],
    address:   ENV['sendgrid_host'],
    password:  ENV["sendgrid_pass"]
  }

	config.action_mailer.delivery_method       = :smtp
	config.action_mailer.perform_deliveries    = true
  config.action_mailer.raise_delivery_errors = false
end
