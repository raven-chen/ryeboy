Airbrake.configure do |config|
  config.api_key = '52e1efaaf1fb6f8da6248c07add6b0a3'
  config.host    = 'bugs.ryeboy.com'
  config.port    = 80
  config.secure  = config.port == 443
end
