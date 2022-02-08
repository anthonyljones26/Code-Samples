Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
  config.webpacker.check_yarn_integrity = true
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  config.action_controller.perform_caching = true
  config.cache_store = :redis_cache_store, {
    host: REDIS_CONFIG['host'],
    port: REDIS_CONFIG['port'],
    db: REDIS_CONFIG['db'],
    ssl: REDIS_CONFIG['ssl'].eql?('true'),
    password: REDIS_CONFIG['password'].presence,
    namespace: '_portal-allergy_vials',
    expire_after: REDIS_CONFIG['expire_minutes'].to_i.minutes
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::FileUpdateChecker

  # Setup default url options to be used by url helpers
  config.action_controller.default_url_options = { protocol: ENV['URL_PROTOCOL'] || 'http' }
end
