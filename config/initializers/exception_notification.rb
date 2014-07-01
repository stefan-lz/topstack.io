Rails.application.config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[TopStack] ",
    :sender_address => %{"Exception Notifier" <exception.notifier@topstack.io>},
    :exception_recipients => [Rails.application.secrets.exception_notification_recipient]
  }
