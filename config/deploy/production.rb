set :stage, :production

set :user, 'angler'
set :use_sudo, :false

server 'db.orta.xyz', user: 'angler', roles: %{db}
server 'subscribe.coincycle.co', user: 'angler', roles: %w{web app}
