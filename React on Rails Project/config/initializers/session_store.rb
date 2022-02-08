# Be sure to restart your server when you modify this file.

Rails.application.config.session_store(
  :token_session_store,
  key: "_#{Rails.application.class.parent_name.downcase}_session",
  expire_after: REDIS_CONFIG['expire_minutes'].to_i.minutes,
  logger: Rails.logger,
  jwk_issuer_whitelist: APP_CONFIG['dex_issuer_jwk_xref']
)
