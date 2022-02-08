ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
ENV['RACK_ENV'] = ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'

require 'bundler/setup' # Set up gems listed in the Gemfile.
