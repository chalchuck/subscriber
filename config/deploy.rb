lock '3.5.0'

Dir.glob("lib/capistrano/tasks/*.rb").sort.each { |r| load r }

set :user, "angler"
set :application, 'subscribe'
set :repo_url, "git@bitbucket.org:chalchuck/subscribe.git"

# set :sidekiq_pid, "/home/#{fetch(:user)}/#{fetch(:application)}/current/tmp/pids/sidekiq.pid"
set :sidekiq_log, "/home/#{fetch(:user)}/#{fetch(:application)}/current/log/sidekiq.log"
set :sidekiq_config, "/home/#{fetch(:user)}/#{fetch(:application)}/current/config/sidekiq.yml"
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :scm, :git

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :format, :airbrussh
set :format_options, color: :auto, truncate: 130
set :banner, "Lets make this ROCKET RISE!"
set :log_level, :info
set :pty, false
set :command_output, false
set :use_sudo, :false
set :keep_releases, 5

set :assets_roles, [:app]
set :rvm_roles, :app
set :bundle_roles, :app
set :migration_role, :app


set :puma_threads,    [1, 16]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{current_path}/log/puma.error.log"
set :puma_error_log,  "#{current_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end
