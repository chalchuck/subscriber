set :redis_pid, "/var/run/redis/redis-server.pid"
set :redis_port, 6379

namespace :redis do
	desc "Install the latest release of Redis on the server"
	task :install do
		on roles (:app) do
			execute :sudo ,"apt-get install -y python-software-properties"
			execute :sudo ,"add-apt-repository -y ppa:chris-lea/redis-server"
			execute :sudo ,"apt-get -y update"
			execute :sudo ,"apt-get -y install redis-server"
		end
	end
	after "deploy:install", "redis:install"

	%w[start stop restart status].each do |command|
		desc "#{command} redis"
		task "#{command}" do
			on roles (:app) do
				execute :sudo ,"service redis-server #{command}"
			end
		end
	end
end
