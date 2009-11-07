RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session_store = :memory_store
  config.action_controller.session = {
    :session_key => '_enki_session',
    :secret      => 'd9b13a4ed2cfce88d62a6765b99530fd5a984ac827aa9068bf893aff51233f486c5f57f83d537945fb89caf2cd8bd3f42a5c3bfc5adce818afe28fca0452b52b'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  config.gem "db2s3", :source => "http://gemcutter.org"

  Dir.glob(File.join(RAILS_ROOT,'vendor','*','lib')).each do |dir|
    config.load_paths += [dir]
  end
end

require 'lesstile'
require 'coderay'

require 'core_extensions/string'
require 'core_extensions/object'

require 'openid'
require 'openid/store/filesystem'
require 'openid/extensions/sreg'

require 'chronic'
