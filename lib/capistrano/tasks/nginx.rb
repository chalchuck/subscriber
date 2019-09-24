namespace :nginx do
  desc "Install the latest stable release of nginx"
  task :install do
    on roles(:web) do
      execute :sudo, "apt-get -y install python-software-properties"
      execute :sudo, "add-apt-repository -y ppa:nginx/stable"
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install nginx"
    end
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx and its configurations for the application"
  task :setup do
    on roles (:web) do
      execute :sudo, "mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default"
      template "nginx.erb", "/tmp/nginx_confd"
      execute :sudo, "mv /tmp/nginx_confd /etc/nginx/nginx.conf"
      execute :sudo, "rm -f /etc/nginx/sites-enabled/default"
      template "nginx_unicorn.erb", "/tmp/nginx.conf"
      execute :sudo, "mv /tmp/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}.conf"
      invoke "nginx:restart"
    end
  end
  before "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command do
      on roles (:web) do
        execute :sudo, "service nginx #{command}"
      end
    end
    after "deploy:#{command}", "nginx:#{command}"
  end
end
