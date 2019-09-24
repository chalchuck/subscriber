namespace :postfix do

	desc "Install Postfix loopback only"
	task :install do
		on roles (:all) do
			info "Installing POSTFIX...."
			execute :sudo, 'DEBIAN_FRONTEND=noninteractive apt-get -y install postfix'
			info "Successfully installed POSTFIX"
		end
	end

	after "deploy:install", "postfix:install"

	desc "Install Postfix loopback only"
	task :setup do
		on roles (:all) do
			execute :sudo, 'bash -c  "echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections"'
			execute :sudo, 'bash -c  "echo "postfix postfix/mailname string localhost" | debconf-set-selections"'
			execute :sudo, 'bash -c  "echo "postfix postfix/destinations string localhost.localdomain, localhost" | debconf-set-selections"'
			execute :sudo, '/usr/sbin/postconf -e "inet_interfaces = loopback-only";'
			execute :sudo, '/usr/sbin/postconf -e "local_transport = error:local delivery is disabled"'
			invoke "postfix:restart"
		end
	end
	after "postfix:install", "postfix:setup"

	%w[start stop restart reload flush check abort force-reload status].each do |command|
		desc "#{command} postfix"
		task command do
			on roles (:all) do
				execute :sudo, "service postfix #{command}"
			end
		end
	end
end
