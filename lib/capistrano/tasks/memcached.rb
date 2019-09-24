set :memcached_port, "11211"
set :memcached_memory_limit, 32
set :memcached_log_file, "/var/log/memcached.log"
set :memcached_pid_file, "/var/run/memcached.pid"

namespace :memcached do
	desc "Install Memcached"
	task :install do
		on roles (:app) do
			execute :sudo, "DEBIAN_FRONTEND=noninteractive apt-get -y update"
			execute :sudo, "DEBIAN_FRONTEND=noninteractive apt-get -y install memcached"
		end
	end
	after "deploy:install", "memcached:install"

	desc "Setup Memcached"
	task :setup do
		on roles (:app) do
			template "memcached.erb", "/tmp/memcached.conf"
			execute :sudo, "mv /tmp/memcached.conf /etc/memcached.conf"
		end
		invoke "memcached:restart"
	end
	after "memcached:install", "memcached:setup"

	%w[start stop restart].each do |command|
		desc "#{command} Memcached"
		task command do
			on roles (:app) do
				execute :sudo, "service memcached #{command}"
			end
		end
		after "deploy:#{command}", "memcached:#{command}"
	end
end
