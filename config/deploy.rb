set :application, "vanct"
set :repo_url,    "git@github.com:dangquangthai/vanct.git"
set :user,        'ubuntu'
set :puma_threads, [4, 16]
set :puma_workers, 0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :linked_files,    %w{config/master.key config/credentials.yml.enc}
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_user,       fetch(:user)
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_restart_command, 'bundle exec puma'
set :puma_service_unit_name, "puma_#{fetch(:application)}_#{fetch(:stage)}"
set :puma_service_unit_env_file, '/etc/environment'
set :puma_phased_restart, true
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

namespace :debug do
  desc 'Print ENV variables'
  task :env do
    on roles(:app), in: :sequence, wait: 5 do
      execute :printenv
    end
  end
end

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
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      # unless %x{git rev-parse HEAD} === %x{git rev-parse origin/master}
      #   puts "WARNING: HEAD is not the same as origin/master"
      #   puts "Run `git push` to sync changes."
      #   exit
      # end
    end
  end

  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end

        unless test("[ -f #{shared_path}/config/credentials.yml.enc ]")
          upload! 'config/credentials.yml.enc', "#{shared_path}/config/credentials.yml.enc"
        end
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc "Load the initial schema - it will WIPE your database, use with care"
  task :db_schema_load do
    on roles(:db) do
      puts <<~WARN
        ************************** WARNING ***************************
        If you type [YES], rake db:schema:load will WIPE your database
        any other input will cancel the operation.
        **************************************************************
      WARN

      ask :answer, "Are you sure you want to WIPE your database?: "

      if fetch(:answer) == 'YES'
        within release_path do
          with rails_env: fetch(:stage) do
            execute :rake, "db:environment:set RAILS_ENV=#{fetch(:stage)}"
            execute :rake, "db:schema:load RAILS_ENV=#{fetch(:stage)} DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
          end
        end
      else
        puts "Cancelled."
        exit
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  # after  :finishing,    :restart
end

before "deploy:assets:precompile", "deploy:yarn_install"

namespace :deploy do
  desc "Run rake yarn:install"
  task :yarn_install do
    # on roles(:web) do
    #   within release_path do
    #     execute("which yarn && ls -la && cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
    #     execute("echo $(pwd) && echo $(which yarn) && echo $(ls -la)")
    #   end
    # end
  end
end

# task :execute_patches do
#   on roles(:app) do |h|
#     within release_path do
#       with rails_env: fetch(:stage) do
#         execute :rake, "patches:run RAILS_ENV=#{fetch(:stage)}"
#       end
#     end
#   end
# end
# after :deploy, :execute_patches

if ENV["RUN_DB_SCHEMA_LOAD"] == '1'
  before "deploy:migrate", "deploy:db_schema_load"
end

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure