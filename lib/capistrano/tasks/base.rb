def template(from, to, as_root = false)
  template_path = File.expand_path("../../templates/#{from}", __FILE__)
  template = ERB.new(File.new(template_path).read).result(binding)
  upload! StringIO.new(template), to

  sudo "chmod 644 #{to}"
  sudo "chown angler:admin #{to}" if as_root == true
end

namespace :deploy do

  desc "Install application environment"
  task :install do
    on roles(:all), in: :groups, limit: 3, wait: 10 do
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install python-software-properties build-essential zlib1g zlib1g-dev libssl-dev libreadline6 libreadline6-dev openssh-server libyaml-dev libcurl4-openssl-dev libxslt-dev libxml2-dev openssl curl autoconf libc6-dev ncurses-dev automake libtool bison"
      info 'System updated'
    end
  end

  desc 'Finish Install'
  task :finish_install do
    on roles(:all), in: :sequence, wait: 5 do
    end
  end
  # after "security:install", "deploy:finish_install"

  desc 'Setup environment'
  task :setup do
    on roles(:all), in: :sequence, wait: 5 do
      info 'Settingup Bitbucket deployment keys'
      execute "ssh-keyscan  bitbucket.org  >> ~/.ssh/known_hosts"
      execute "ssh -T git@bitbucket.org"
    end
  end

  desc 'Restart environment'
  task :restart_env do
    on roles(:all), in: :sequence, wait: 5 do
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end
