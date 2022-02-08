if Rails.env.test? || Rails.env.development?
  Portal::DexFrameworkMock.setup do |config|
    config.pagelets = DEX_CONFIG['pagelets']
    config.token_defaults = DEX_CONFIG['token_defaults']
  end
end
