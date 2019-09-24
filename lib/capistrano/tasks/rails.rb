set :deploy_secret, "y"
set :secret_key_base, proc { `bundle exec rake secret`.chomp }.call
set :secrets_config, -> {"#{shared_path}/config/secrets.yml"}

namespace :deploy do
	namespace :rails do
		desc "Setup secret key base file in rails app environment"
		task :secrets do
			on roles :app do
				execute "mkdir -p #{shared_path}/config"
				template "secrets.yml.erb", '/tmp/secrets_rb'
				execute :sudo, "mv /tmp/secrets_rb #{fetch(:secrets_config)}"
				execute :sudo, "rm #{release_path}/config/secrets.yml"
				execute :sudo, "ln -s #{fetch(:secrets_config)} #{release_path}/config/secrets.yml"
			end
		end
		before "deploy:publishing", "deploy:rails:secrets"

		desc "Generate the database.yml configuration file."
		task :database_yml do
			on roles :app do
				template "postgresql.yml.erb", "/tmp/database_yml"
				execute "mkdir -p #{shared_path}/config"
				execute :sudo, "mv /tmp/database_yml", "#{shared_path}/config/database.yml"
			end
		end
		before "deploy:updated", "deploy:rails:database_yml"

	  desc "Make rails bin executable."
	  task :permissions do
	  	on roles :app do
	  		within "/home/angler/#{fetch(:application)}/current/" do
	        execute :chmod, "u+x bin/rails"
	      end
    		within release_path do
          execute :chmod, "u+x bin/rails"
        end
	  	end
	  end
	  before "deploy:restart", "deploy:rails:permissions"
	end
end
