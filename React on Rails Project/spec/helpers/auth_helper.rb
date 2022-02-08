module PortalAllergyVials
  module AuthHelper
    SESSION_TYPE = {
      multiple: 'spec/fixtures/accessible_persons/multiple_user.json',
      single: 'spec/fixtures/accessible_persons/single_user.json',
      no_mrn: 'spec/fixtures/accessible_persons/no_mrn.json'
    }.freeze

    INSURANCE_TYPE = {
      error: -> { raise Portal::HcoApi::Services::Errors::UnprocessableEntityError },
      insurance: -> { 'spec/fixtures/health_plans/insurance.json' },
      mu_insurance: -> { 'spec/fixtures/health_plans/mu_insurance.json' },
      no_insurance: -> { 'spec/fixtures/health_plans/no_insurance.json' }
    }.freeze

    def visit_index(session_type = :single, insurance_type = :insurance)
      mock_middlware_session_response(session_type, insurance_type)
      mock_healthelife_api(session_type) do
        mock_mobjects_health_plans(INSURANCE_TYPE[insurance_type]) do
          visit root_url(bcs_token: 'abc')
          expect(page).to have_selector 'h1', text: 'Allergy Vial Refills'
        end
      end
    end

    def switch_patients(patient_name, patient_index, insurance_type = :insurance)
      find('div[class*=toggle-patient-switcher]').click
      mock_mobjects_health_plans(INSURANCE_TYPE[insurance_type]) do
        find("div[class*=toggle-patient-switcher] li:nth-of-type(#{patient_index})", text: patient_name).click
        block_given? ? yield : expect_selector_containing('tide-patient-switcher-active', patient_name)
      end
    end

    def expect_selector_containing(class_name, selector_text = '')
      expect(page).to have_selector "div[class*=#{class_name}]", text: selector_text
    end

    def expect_no_selector_containing(class_name, selector_text = '')
      expect(page).to have_no_selector "div[class*=#{class_name}]", text: selector_text
    end

    private

    def mock_mobjects_health_plans(insurance_type)
      allow(Portal::CareawareApi::Services::Mobjects::HealthPlans)
        .to receive(:retrieve_user_health_plans) do
          # never called on insurance_type :error
          Portal::CareawareApi::Model::Mobjects::HealthPlan.from_array load_json(insurance_type.call)
        end
      yield
      allow(Portal::CareawareApi::Services::Mobjects::HealthPlans)
        .to receive(:retrieve_user_health_plans).and_call_original
    end

    def mock_healthelife_api(session_type)
      allow_any_instance_of(Portal::HealthelifeApi)
        .to receive(:get_accessible_persons_with_ch_record_id) { load_json(SESSION_TYPE[session_type]) }
      yield
      allow_any_instance_of(Portal::HealthelifeApi)
        .to receive(:get_accessible_persons_with_ch_record_id).and_call_original
    end

    def mock_middlware_session_response(session_type, insurance_type)
      principal = "#{session_type}#{insurance_type}"
      allow_any_instance_of(ActionDispatch::Session::TokenSessionStore).to receive(:decode_token) {
        {
          'aud' => root_url,
          'exp' => Time.now.to_i + 10 * 3600,
          'iat' => Time.now.to_i,
          'iss' => 'http://tide-alt.test:3000',
          'sid' => '00000000-0000-0000-0000-000000000000',
          'sub' => "urn:cerrner:identity-federation:realm:REALM_HERE:principal:#{principal}"
        }.with_indifferent_access
      }
    end

    def load_json(filename)
      JSON.parse(File.read(Rails.root.join(filename))).map(&:deep_symbolize_keys)
    rescue StandardError
      []
    end
  end
end
