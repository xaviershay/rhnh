desc "Force production env, handy with god"
task :force_production do
  ENV["RAILS_ENV"] = 'production'
  RAILS_ENV = 'production'
end
