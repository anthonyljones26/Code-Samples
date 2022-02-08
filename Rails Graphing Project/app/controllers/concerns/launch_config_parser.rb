require 'optparse'

module Concerns
  module LaunchConfigParser
    extend ActiveSupport::Concern
    included do
      before_action :parse
    end

    def parse
      cerrner_srg = session.fetch(:token_response, nil)&.fetch('cerrner_srg', nil)
      return if session[:launch_config_raw] == cerrner_srg && session[:launch_config].present?

      options = {
        time_range: GRAPH_CONFIG['date_range']['default'].to_sym,
        components: []
      }

      session[:launch_config_raw] = cerrner_srg
      unless cerrner_srg.nil?
        cerrner_srg_parts = cerrner_srg.split(' ')
        options.merge!(global_parse(cerrner_srg_parts))
        options[:components] = cerrner_srg_parts.map { |app| component_parse(app.split('.')) }
      end

      options[:components] = default_components if options[:components].empty?
      session[:launch_config] = options
    end

    def global_parse(args)
      options = {}
      OptionParser.new do |opts|
        opts.on('-tTIME_RANGE', 'Time Range') do |opt|
          raise "invalid time range option: #{opt}" unless GRAPH_CONFIG['date_range']['options'].keys.include?(opt)

          options[:time_range] = opt.to_sym
        end
      end.parse!(args)
      options
    end

    def component_parse(args)
      component_options = {
        component_type: nil,
        observation_type: nil,
        is_maximized: true,
        is_single: false
      }
      args.each do |arg|
        get_component_options(arg, component_options)
      end

      case component_options[:component_type]
      when :OBS
        component_options[:observation_type] ||= GRAPH_CONFIG['default_observation'].to_sym
      when :MED
        component_options[:is_single] = true
      else
        raise "unknown component: #{component_options[:component_type]}"
      end
      component_options
    end

    def get_component_options(arg, options)
      case arg
      when *GRAPH_CONFIG['components'].keys
        options[:component_type] = arg.to_sym
      when *GRAPH_CONFIG['observations'].keys
        options[:observation_type] = arg.to_sym
      when 'm'
        options[:is_maximized] = false
      when 'M'
        options[:is_maximized] = true
      when 's'
        options[:is_single] = true
      else
        raise "invalid component option: #{arg}"
      end
      options
    end

    def default_components
      [
        component_parse(['OBS']),
        component_parse(['MED'])
      ]
    end
  end
end
