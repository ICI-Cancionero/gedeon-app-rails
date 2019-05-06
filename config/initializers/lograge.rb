Rails.application.configure do
  # Lograge config
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new
  config.lograge.keep_original_rails_log = true
  logger = ActiveSupport::Logger.new "#{Rails.root}/log/lograge_#{Rails.env}.log"
  config.lograge.logger = logger

  if Rails.env.production?
    config.colorize_logging = false
  end

  config.lograge.custom_options = lambda do |event|
    {
      :params => event.payload[:params],
      :level => event.payload[:level],
      :remote_ip => event.payload[:remote_ip],
      :user_id => event.payload[:user_id],
      :user_email => event.payload[:user_email],
      :time => event.time,
      :user_agent => event.payload[:user_agent]
    }
  end
end