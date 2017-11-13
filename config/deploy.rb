# config valid for current version and patch releases of Capistrano
lock '~> 3.10.0'

set :application, ENV['APPLICATION'] || 'template_web'
set :repo_url, 'git@github.com:taka10257/rails5-react-capistrano-puma-nginx-starter.git'
set :log_level, :debug
set :user, 'deploy'
set :password, 'deploy'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, "/var/www/#{fetch(:application)}"
set :deploy_via, :remote_cache

# bundle
set :bundle_path, -> { shared_path.join('vendor/bundle') }

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true
set :use_sudo, false

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 3
set :keep_releases, 2

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log, "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to false when not using ActiveRecord

set :rbenv_type, :system
set :rbenv_ruby, '2.4.2'

# set :linked_files, %w[.rbenv-vars]
# set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')
# set :linked_dirs, %w[bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system]
set :config_files, %w[config/database.yml config/secrets.yml]

set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system',
  'public/uploads'
)
# set :linked_files, %w{config/database.yml}

set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml',
  'config/secrets.yml',
  '.env'
)

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Make sure local git is in sync with remote.'
  task :confirm do
    on roles(:app) do
      puts "This stage is '#{fetch(:stage)}'. Deploying branch is '#{fetch(:branch)}'."
      puts 'Are you sure? [y/n]'
      ask :answer, 'n'
      if fetch(:answer) != 'y'
        puts 'deploy stopped'
        exit
      end
    end
  end

  desc 'Upload config'
  task :upload_config do
    on roles(:app) do
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      upload!('config/database.yml', "#{shared_path}/config/database.yml")
      upload!('config/secrets.yml', "#{shared_path}/config/secrets.yml")
    end
  end

  namespace :db do
    desc 'bundle exec rake db:create'
    task :create do
      on roles(:db) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:create'
            # run "cd #{current_path} && bundle exec rake db:create RAILS_ENV=#{rails_env}"
          end
        end
      end
    end

    desc 'bundle exec rake db:seed'
    task :seed do
      on roles(:db) do
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute :rake, 'db:seed'
          end
        end
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:migrate', 'deploy:db:create'
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  before :starting, :confirm
  before :starting, :upload_config
  before 'deploy:check:linked_files', :upload_config
  after :finishing, :compile_assets
  after :finishing, :cleanup
end
