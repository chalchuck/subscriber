namespace :nodejs do
	desc "Install the latest relase of Node.js"
	task :install do
		on roles :app do
			info "Installing NodeJS..."
			# execute :sudo, "add-apt-repository -y ppa:chris-lea/node.js"
			execute :sudo, "apt-get -y update"
			execute :sudo, "apt-get -y install nodejs"
			info "NodeJS succssfully installed"
		end
	end
	after "deploy:install", "nodejs:install"
end
