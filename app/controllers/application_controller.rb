class ApplicationController < ActionController::Base
  EPOCH = Time.parse("2011-07-29 16:28:28 +1000")

  # TODO: Remove after Rails 4 upgrade
  # https://github.com/rails/rails/issues/9619
  config.relative_url_root = ""

  protect_from_forgery
  after_filter :set_content_type

  protected

  def set_content_type
    headers['Content-Type'] ||= 'text/html; charset=utf-8'
  end

  def enki_config
    @@enki_config = Enki::Config.default
  end
  helper_method :enki_config
end
