Moiper.configure do |config|
  config.sandbox = Settings.moip.environment != 'production'
  config.token   = Settings.moip.token
  config.key     = Settings.moip.key
end
