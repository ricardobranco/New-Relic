# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'new_relic'
set :repo_url, 'git@github.com:ricardobranco/New-Relic.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/new_relic'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}
desc "Database config"
  task :setup_config, roles: :app do
  # upload you database.yml from config dir to shared dir on server
  put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
  # make symlink
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # upload you database.yml from config dir to shared dir on server
  put File.read(".env"), "#{shared_path}/config/.env"
  # make symlink
  run "ln -nfs #{shared_path}/config/.env #{current_path}/.env"
end

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
