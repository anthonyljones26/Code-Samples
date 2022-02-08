# rubocop:disable Metrics/BlockLength
require 'vcr'
require_relative 'vcr_base'

module VcrSetup
  extend VcrBase

  REGEX = {
    datetime: /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:Z|(?:[+-]|%2B)\d{2}:?\d{2})/
  }.freeze

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    c.hook_into :webmock
    c.ignore_localhost = true
    c.ignore_request do |request|
      uri = URI(request.uri)
      uri.host == 'hub' # ignore special alias to your host loopback interface
    end
    c.allow_http_connections_when_no_cassette = true
    c.configure_rspec_metadata!

    # helper to remove seconds and minutes from datetime in uri of requests
    c.register_request_matcher :ignore_seconds do |request_one, request_two|
      dates = request_one.uri.scan(REGEX[:datetime]).uniq
      dates.each do |date|
        request_one.uri.sub!(date, "#{date[0..12]}:00")
      end

      dates = request_two.uri.scan(REGEX[:datetime]).uniq
      dates.each do |date|
        request_two.uri.sub!(date, "#{date[0..12]}:00")
      end

      # just editing the uri, return true and use other matchers to do actual matching
      true
    end

    c.default_cassette_options = {
      record: :new_episodes,
      match_requests_on: [
        :method,
        :ignore_seconds,
        VCR.request_matchers.uri_without_param(:code)
      ]
    }

    c.before_http_request do |request|
      uri = URI(request.uri)
      if uri.host == 'authorization.sandboxcerrner.com'
        VCR.insert_cassette('custom/' + VcrSetup.safe_name(uri.host))
      elsif uri.host == 'fhir-ehr.sandboxcerrner.com' && uri.path.include?('metadata')
        VCR.insert_cassette('custom/' + VcrSetup.safe_name('fhir-ehr.sandboxcerrner.com::metadata'))
      end
    end

    c.after_http_request do |request, _response|
      uri = URI(request.uri)
      VCR.eject_cassette if uri.host == 'authorization.sandboxcerrner.com'
      VCR.eject_cassette if uri.host == 'fhir-ehr.sandboxcerrner.com' && uri.path.include?('metadata')
    end

    c.before_playback(:do_delay) do
      sleep 0.01 # artificial delay to help with capturing screenshots of loading indicators
    end
  end
end
# rubocop:enable Metrics/BlockLength
