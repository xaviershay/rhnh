RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.action_controller.session_store = :cookie_store
  config.action_controller.session = {
    :session_key => '_enki_session',
    :secret      => 'd9b13a4ed2cfce88d62a6765b99530fd5a984ac827aa9068bf893aff51233f486c5f57f83d537945fb89caf2cd8bd3f42a5c3bfc5adce818afe28fca0452b52b'
  }

  config.gem "RedCloth",    :lib => "redcloth", :version => "~> 4.0"
  config.gem "ruby-openid", :lib => "openid",   :version => "~> 2.1.0"
  config.gem "chronic",  :version => "~> 0.2.0"
  config.gem "coderay",  :version => "~> 0.8.0"
  config.gem "lesstile", :version => "~> 0.3"
  config.gem "will_paginate", :version => "~> 2.3", :source => 'http://gemcutter.org'
  config.gem "db2s3", :source => "http://gemcutter.org"

  config.time_zone = 'UTC'
end
