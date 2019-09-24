set :pg_user, -> {"postgres"}
set :pg_database, ->{"subscribe_production"}
# set :pg_database, ->{"#{fetch(:application)}_#{fetch(:rails_env) || fetch(:stage) }"}
set :pg_password, -> {'lazyg33kg33k'}
set :postgresql_pid, ->{ "/var/run/postgresql/9.5-main.pid" }

namespace :postgresql do
  desc "Install the latest stable release of PostgreSQL."
  task :install do
    on roles(:db, :app) do
      info "Installing PostgreSQL...."
      execute :sudo, %{sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list"}
      execute :sudo, 'wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -'
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install postgresql-9.5 postgresql-common libpq-dev"
      info "Successfully installed PostgreSQL"
    end
  end
  after "deploy:install", "postgresql:install"

  desc "database console"
  task :console do
    auth = capture "cat #{shared_path}/config/database.yml"
    puts "PASSWORD::: #{auth.match(/password: (.*$)/).captures.first}"
    hostname = find_servers_for_task(current_task).first
    exec "ssh #{hostname} -t 'source ~/.zshrc && psql -U #{application} #{pg_database}'"
  end
end
