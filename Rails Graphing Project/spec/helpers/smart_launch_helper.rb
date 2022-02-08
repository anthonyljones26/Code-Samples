# rubocop:disable Metrics/MethodLength
module ResultsGraphingFhir
  module SmartLaunchHelper
    def do_launch(is_expanded_med, is_expanded_bp)
      # this cassette is a catch-all for requests that we can ignore prior to tests with a controlled time travel
      VCR.use_cassette('custom/smart_launch', record: :new_episodes, match_requests_on: %i[host path]) do
        loading_classes = []
        # begin smart launch
        visit build_launch_url

        # first request of suite needs to log into fhir sandbox
        unless current_path == root_path
          within('#loginForm') do
            fill_in 'j_username', with: 'portal'
            fill_in 'j_password', with: 'portal'
            click_button 'loginButton'
          end
        end
        # wait for redirect to root path of our app
        expect(page).to have_current_path(root_path)
        loading_classes.push('.medication-container .preloader-container') if is_expanded_med
        loading_classes.push('.blood-pressure-container .preloader-container') if is_expanded_bp
        unless loading_classes.empty?
          loading_classes = loading_classes.join(', ')
          expect(page).to have_selector(
            loading_classes
          )
          expect(page).not_to have_selector(
            loading_classes
          )
        end
      end
    end

    private

    def build_launch_url
      launch_url = nil
      tenant_id = '0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca'
      client_id = "https://fhir-ehr.sandboxcerrner.com/dstu2/#{tenant_id}"

      do_launch_from_code = true
      if do_launch_from_code
        # launch via previously created launch code
        launch_code = '4b8c2991-5cb2-4bfd-b5f1-d3846cb049d7' # NOTE: assuming this code will eventually expire
        launch_params = {
          iss: client_id,
          launch: launch_code
        }.to_query
        launch_url = "#{fhir_auth.launch_path}?#{launch_params}"
      else
        # launch via faked sandbox launch
        client = FHIR_CLIENTS_CONFIG['clients'][client_id]
        app_id = client['app_id']

        # faked launch params for "Peters, Tim" on sandboxcerrner
        launch_params = {
          PAT_PersonId: 1316024,
          VIS_EncntrId: 2619906,
          PAT_PPRCode: '',
          USR_PersonId: 4464007,
          username: 'portal',
          need_patient_banner: true
        }.to_query
        launch_url = "https://smart.sandboxcerrnerpowerchart.com/smart/#{tenant_id}/apps/#{app_id}?#{launch_params}"
      end

      launch_url
    end
  end
end
# rubocop:enable Metrics/MethodLength
