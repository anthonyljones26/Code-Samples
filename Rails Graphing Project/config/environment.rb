# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
Rails.application.config.event_logger = Logger.new('log/event.log')
Rails.application.config.error_logger = Logger.new('log/error.log')
Rails.application.config.difference_logger = Logger.new('log/difference.log')
Rails.application.config.event_logger.level = Logger::INFO
Rails.application.config.error_logger.level = Logger::INFO
Rails.application.config.difference_logger.level = Logger::INFO
