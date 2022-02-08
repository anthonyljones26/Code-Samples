require_relative 'smart_launch_helper'

module ResultsGraphingFhir
  module SessionHelper
    include ResultsGraphingFhir::SmartLaunchHelper

    def setup_session(cerrner_srg = nil, is_expanded_med: true, is_expanded_bp: true)
      current_session = set_mock_session(cerrner_srg)
      if current_session['token_response']
        # NOTE: uncomment to make a new session when token expired, otherwise app will try to refresh token

        # time_expires = current_session['token_response']['created_at'].to_time
        # time_expires += current_session['token_response']['expires_in'].to_i
        # if Time.now >= time_expires
        #   do_launch
        #   write_mock_session_to_file(mock_session)
        # end
      else
        do_launch(is_expanded_med, is_expanded_bp)
        write_mock_session_to_file(mock_session)
      end
    end

    private

    def set_mock_session(cerrner_srg)
      visit mock_session_set_path(cerrner_srg: cerrner_srg)
      JSON.parse(find(:xpath, '//body').text)
    end

    def mock_session
      visit mock_session_path
      JSON.parse(find(:xpath, '//body').text)
    end

    def write_mock_session_to_file(current_session)
      File.open(Rails.root.join('spec/fixtures/sessions/valid_session.json'), 'w') do |f|
        f.puts current_session.to_json
      end
    end
  end
end
