Fhir::AuthEngine.setup do |config|
  config.fhir_clients = FHIR_CLIENTS_CONFIG['clients']
end
