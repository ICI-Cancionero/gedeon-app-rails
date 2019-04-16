Rails.application.configure do
  # Lograge config
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new

  if Rails.env.production?
    config.colorize_logging = false
  end

  config.lograge.custom_options = lambda do |event|
    {
      :params => event.payload[:params],
      :level => event.payload[:level],
    }
  end
end