# Be sure to restart your server when you modify this file.

Rails.application.config.session_store(
  :redis_store,
  servers: [
    {
      host: ENV['REDIS_HOST'],
      port: REDIS_CONFIG['port'],
      db: REDIS_CONFIG['db'],
      password: ENV['REDIS_PASSWORD'].present? ? ENV['REDIS_PASSWORD'] : nil,
      ssl: REDIS_CONFIG['ssl'],
      namespace: '_results-graphing-fhir_session'
    }
  ],
  key: "_#{Rails.application.class.parent_name.downcase}_session",
  expires_in: 60.minutes,
  size: 512.megabytes
)
