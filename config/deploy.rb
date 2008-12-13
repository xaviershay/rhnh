set :application, "rhnh-enki"
set :repository,  "git://gitorious.org/enki/rhnh.git"
set :user, 'xavier'
set :applicationdir, 'app/rhnh-enki'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "/home/#{user}/#{applicationdir}" 
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git

role :app, "rhnh.net"
role :web, "rhnh.net"
role :db,  "rhnh.net", :primary => true

namespace :deploy do
  task :start do
  end

  task :stop do
  end

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :after_update_code do
    run "cp -f #{shared_path}/config/database.yml #{release_path}/config"
    run "cp -f #{shared_path}/config/defensio.yml #{release_path}/config"
    run "cp -f #{shared_path}/config/mailer.rb #{release_path}/config"
  end
end
