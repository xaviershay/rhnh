desc "Force production env, handy with god"
task :force_production do
  ENV["RAILS_ENV"] = 'production'
  RAILS_ENV = 'production'
end

desc "Force chdir to RAILS_ROOT, handy with god"
task :force_chdir => :environment do
  Dir.chdir(RAILS_ROOT)
end
