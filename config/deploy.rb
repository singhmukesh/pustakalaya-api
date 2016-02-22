#rvm version in server
set :rvm_ruby_version, 'ruby-2.3.0'

#Application name
set :application, 'Pustakalaya API'

# Source code management. Default value for :scm is :git
set :scm, :git

#Server user
set :user, 'deploy'

#Github repo url and branch if needed
set :repo_url, 'git@github.com:leapfrogtechnology/pustakalaya-api.git'

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

#Must be set true for password prompt from git to work
set :pty, true

# Back up 2 previous releases. Default value for keep_releases is 5
set :keep_releases, 3

#keep a cached code checkout on the server and do updates each time(more efficient)
set :deploy_via, :remote_cache

#Set staging as default environment
#cap deploy => staging
#cap production deploy => production
set :default_stage, 'staging'

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Reload application'
  task :reload do
    desc "Reload app after change"
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} Nginx."
    task command do
      on roles(:app) do
        execute "sudo service nginx #{command}"
      end
    end
  end

  after :publishing, :reload
end

def rvm_prefix
  "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do"
end

#These are one time tasks for the first deploy
namespace :setup do

  desc "Upload database.yml and application.yml files."
  task :yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
      upload! StringIO.new(File.read("config/application.yml")), "#{shared_path}/config/application.yml"
    end
  end

  desc "Create the database."
  task :db_create do
    on roles(:app) do
      within "#{release_path}" do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:create"
        end
      end
    end
  end

  desc "Seed the database."
  task :db_seed do
    on roles(:app) do
      within "#{release_path}" do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end

  if fetch(:initial) == "true"
    before 'deploy:migrate', 'setup:db_create'
    after 'deploy:migrate', 'setup:db_seed'
  end

  before 'deploy:starting', 'setup:yml'

end
