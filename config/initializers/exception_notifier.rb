ExceptionNotifier.exception_recipients = [Enki::Config.new[:author, :email]]
require "#{RAILS_ROOT}/config/mailer"
