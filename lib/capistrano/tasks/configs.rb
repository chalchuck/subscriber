namespace :configs do
	desc "Upload configuration files to the server"
	task :upload do
		on roles (:app) do
			dir = "/home/#{fetch(:user)}/#{fetch(:application)}/shared"
			execute "mkdir -p #{dir}"
			%w(application).each do |file|
				info "Uploading #{file}.yml to server"
				template_path = "#{Dir.pwd}/config/#{file}.yml"
				template = ERB.new(File.new(template_path).read).result(binding)
				upload! StringIO.new(template), "/tmp/#{file}.backup.yml"
				execute :sudo, "mv /tmp/#{file}.backup.yml #{dir}/#{file}.yml"
				info "Uploaded #{file}.yml to server"
			end
		end
	end
	after "deploy:updating", "configs:upload"

	desc "Symlink application.yml to the release path"
  task :symlink do
    on roles(:app) do
    	%w(application).each do |file|
				info "Symlinking #{file}.yml to #{current_path}/config/#{file}.yml"
      	execute "ln -sf #{shared_path}/#{file}.yml #{current_path}/config/#{file}.yml"
				info "Symlinking of #{file}.yml complete"
    	end
    end
  end
  after "deploy:symlink:release", "configs:symlink"
end
