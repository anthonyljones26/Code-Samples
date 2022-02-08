Portal::HcoApi.setup do |config|
  config.username = IDX_CONFIG['username']
  config.password = IDX_CONFIG['password']
  config.idx_server = IDX_CONFIG['idx_server']
  config.wsdl = IDX_CONFIG['wsdl']
end
