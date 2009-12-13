RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "RedCloth",    :lib => "redcloth", :version => "~> 4.0"
  config.gem "ruby-openid", :lib => "openid",   :version => "~> 2.1.0"
  config.gem "chronic",  :version => "~> 0.2.0"
  config.gem "coderay",  :version => "~> 0.8.0"
  config.gem "lesstile", :version => "~> 0.3"
  config.gem "will_paginate", :version => "~> 2.3", :source => 'http://gemcutter.org'
  config.gem "db2s3", :source => "http://gemcutter.org"

  config.time_zone = 'UTC'
end
