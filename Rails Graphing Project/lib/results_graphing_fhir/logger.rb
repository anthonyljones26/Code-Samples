require 'logger'
module ResultsGraphingFhir
  module Logger
    def event_logger(provider, event_domain, event_type, description)
      provider = provider.blank? ? '-' : provider
      event_domain = event_domain.blank? ? '-' : event_domain
      event_type = event_type.blank? ? '-' : event_type
      description = description.blank? ? '-' : description
      Rails.configuration.event_logger.info(" [#{provider}] [#{event_domain}] [#{event_type}] [#{description}]")
    end

    def log_user_event(event_domain = '-', event_type = '-', description = '-')
      provider = session['token_response'] && session['token_response']['user']
      event_logger(provider, event_domain, event_type, description)
    end

    def log_method_error(error, error_location)
      provider = session['token_response'] && session['token_response']['user']
      error_location = "#{self.class.name || '-'}.#{error_location || '-'}"
      error_type = error.class.nil? ? '-' : error.class
      error_logger(provider, error_location, error_type, error)
    end

    def log_other_error(error_location = '-', error_type = '-', description = '-')
      provider = session['token_response'] && session['token_response']['user']
      error_location = "#{self.class.name || '-'}.#{error_location || '-'}"
      error_logger(provider, error_location, error_type, description)
    end

    def error_logger(provider, error_location, error_type, description)
      provider = provider.blank? ? '-' : provider
      error_type = error_type.blank? ? '-' : error_type
      description = description.blank? ? '-' : description
      Rails.configuration.error_logger.error(" [#{provider}] [#{error_location}] [#{error_type}] [#{description}]")
    end

    def log_medication_difference(key, med_statement, med_order)
      med_statement_value = med_statement&.dig(key) || '-'
      med_order_value = med_order&.dig(key) || '-'
      key_value = key || '-'
      difference_logger(key_value, med_statement_value, med_order_value)
    end

    def difference_logger(key, value_a, value_b)
      Rails.configuration.difference_logger.info(" [#{key}] [#{value_a}] [#{value_b}]")
    end
  end
end
