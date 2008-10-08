ExceptionNotifier.exception_recipients = [Enki::Config.new("config/enki.yml")[:author, :email]]
require 'config/mailer'
