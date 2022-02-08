Portal::CareawareApi.setup do |config|
  config.consumer_key = CA_CONFIG['consumer_key']
  config.consumer_secret = CA_CONFIG['consumer_secret']
  config.services_directory_url = CA_CONFIG['services_directory_url']
  config.authority = CA_CONFIG['authority']
  config.mobjects_service_key = CA_CONFIG['mobjects_service_key']
  config.messaging_service_key = CA_CONFIG['messaging_service_key']
  config.oauth_service_key = CA_CONFIG['oauth_service_key']
end
