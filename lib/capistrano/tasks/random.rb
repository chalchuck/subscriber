namespace :random do
	desc "Install Essentials"
	task :colors do
		on roles(:all), in: :groups, limit: 3, wait: 10 do
			execute :sudo, "DEBIAN_FRONTEND=noninteractive apt-get -y install curl wget vim less htop"
			execute :sudo, "DEBIAN_FRONTEND=noninteractive apt-get -y install imagemagick libmagickwand-dev"
			execute :sudo, %{sed -i -e 's/^#PS1=/PS1=/' /root/.bashrc}
			info 'Essentials installed'
		end
	end
	after "deploy:install", "random:colors"
end

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-mosh-on-a-vps
