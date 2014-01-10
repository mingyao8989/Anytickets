require "bundler/capistrano"
require "whenever/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"
load "config/recipes/utils"
load "config/recipes/rake"
load "config/recipes/taps"
load "config/recipes/monit"

server "69.41.167.90", :web, :app, :db, primary: true

set :user, "deployer"
set :password, "StEwRur8"

set :application, "allseats"
set :deploy_to, "/home/#{user}/apps/#{application}"
# set :deploy_via, :checkout
set :deploy_via, :remote_cache
set :use_sudo, false

set :whenever_command, "bundle exec whenever"

set :scm, "git"
set :repository, "git@github.com:mingyao8989/Anytickets.git" #"git@github.com:rubinsh/AllSeats.git" #"https://github.com/rubinsh/AllSeats.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:paranoid] = false
# ssh_options[:verbose] = :debug
# ssh_options[:username] = 'deployer'
# ssh_options[:host_key] = 'ssh-dss'


after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  desc "Update the crontab file"
  task :update_crontab, roles: :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end
