# config valid only for current version of Capistrano
lock '3.4.0'

set :repo_url, 'git@github.com:raven-chen/ryeboy.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', ".git")

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  desc "Restart unicorn"
  task :restart do
    on roles(:app) do
      execute("kill -USR2 `cat /tmp/#{fetch(:application)}.pid`")
    end
  end

  task :stop do
    on roles(:app) do
      execute("kill -QUIT `cat /tmp/#{fetch(:application)}.pid`")
    end
  end

  task :start do
    on roles(:app) do
      execute("cd #{release_path} && UNICORN_SOCK_FILE=/tmp/#{fetch(:application)}.sock UNICORN_PID_FILE=/tmp/#{fetch(:application)}.pid HOME_DIR=#{current_path}  bundle exec unicorn -E production -D -c #{release_path}/config/system/unicorn.conf.rb")
    end
  end

  task :publishing, roles(:app) do
    invoke "deploy:restart"
  end
end
