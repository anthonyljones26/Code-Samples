module ResultsGraphingFhir
  module TimeTravelHelper
    def visit_with_time_travel(url, new_time, mock_data = nil)
      Timecop.travel(new_time)
      send(mock_data) unless mock_data.nil?
      visit add_url_params(url, time_travel: new_time.iso8601)
    end

    private

    def add_url_params(url, param_hash)
      uri = URI(url)
      params = URI.decode_www_form(uri.query || '')
      param_hash.each do |key, value|
        params << [key, value]
      end
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end
  end
end
