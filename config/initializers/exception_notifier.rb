ExceptionNotifier.exception_recipients = [Enki::Config.new("config/enki.yml")[:author, :email]]
ExceptionNotifier.smtp_settings.merge!(
  :address   => 'mail.messagingengine.com',
  :user_name => Base64.decode64("eGF2aWVyQGZhc3RtYWlsLmZt\n"),
  :password  => Base64.decode64("aDR5d2hhdHNnb2luZ29u\n"),
  :authentication => :plain
)
