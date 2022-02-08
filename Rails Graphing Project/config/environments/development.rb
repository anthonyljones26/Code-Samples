Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable caching
  config.cache_store = :redis_store, {
    host: ENV['REDIS_HOST'],
    port: REDIS_CONFIG['port'],
    db: REDIS_CONFIG['db'],
    ssl: REDIS_CONFIG['ssl'],
    namespace: '_results-graphing-fhir_cache',
    expires_in: REDIS_CONFIG['expire_minutes'],
    password: ENV['REDIS_PASSWORD'],
    size: 512.megabytes
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
  # Poll for file changes, to help when developing with Docker
  config.file_watcher = ActiveSupport::FileUpdateChecker
  # config.reload_classes_only_on_change

  config.action_dispatch.default_headers = {
    'X-XSS-Protection' => '1; mode=block',
    'X-Content-Type-Options' => 'nosniff'
  }
end
