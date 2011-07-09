class ApplicationController < ActionController::Base
  EPOCH = Date.new(2000,1,1).to_time

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
