require "bundler/capistrano"

# If you have custom Sidekiq configuration options put them in config/sidekiq.yml
# require "sidekiq/capistrano"

require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user

set :application, "wakmj"
# set :repository,  "nick@192.168.0.103:www/#{application}"
set :repository,  "deploy@106.187.101.105:www/#{application}"


set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/home/deploy/www/#{application}"
set :branch, 'master'

server "106.187.101.105", :app, :web, :db, :primary => true
set :user, 'deploy'
set :use_sudo, false

default_run_options[:pty] = true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :mongoid_create_indexes, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake db:mongoid:create_indexes"
end

task :resprite, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake assets:resprite"
end

task :compile_assets, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec rake assets:precompile"
end

task :sitemap, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=production rake g:sitemap"
end

# task :start_sidekiq, :roles => :web do
#   run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec sidekiq -C sidekiq.yml ... >> log/sidekiq.log 2>&1"
# end



# task :rm_production_log, :roles => :web do
#   run "cd #{deploy_to}/current/log; #{try_sudo} rm -rf production.log"
# end

after "deploy:finalize_update","deploy:create_symlink", :resprite, :compile_assets, :sitemap
