namespace :git do
	desc "Install git"
	task :install do
		on roles(:all) do
			execute :sudo, "DEBIAN_FRONTEND=noninteractive apt-get -y install git-core"
			info "Git Installed"
		end
	end
	after "deploy:install", "git:install"
end