require 'rails_helper'

RSpec.describe GraphsController, type: :controller do
  context 'raises Redis::CannotConnectError' do
    before(:each) do
      def controller.index
        raise Redis::CannotConnectError
      end
      get :index
    end

    it 'redirects to 500 error page' do
      expect(response).to have_http_status(500)
    end
  end

  context 'when FhirServices::Client error' do
    before(:each) do
      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_observation_by_patient)
        .and_raise('retrieve_observation_by_patient error')

      get :graph_data, format: :json, session: {
        client: {},
        server: {
          url: 'https://fhir-ehr.sandboxcerrner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca',
          oauth2: {
            token_uri: ''
          }
        },
        token_response: {
          'created_at' => Time.now
        }
      }
    end

    it 'renders internal server error 500' do
      expect(response).to have_http_status(500)
      expect(response.body).to eq('{"error":"retrieve_observation_by_patient error"}')
    end
  end

  context 'session[:launch_config]' do
    let(:valid_session_json) { JSON.parse(File.read(Rails.root.join('spec/fixtures/sessions/valid_session.json'))) }
    let(:valid_session) { valid_session_json.with_indifferent_access }

    before(:each) do
      valid_session[:token_response][:created_at] = Time.now
    end
    it 'is set to the default component settings when cerrner_srg is nil' do
      expected_component = [
        { component_type: 'OBS'.to_sym, is_maximized: true, is_single: false, observation_type: 'BP'.to_sym },
        { component_type: 'MED'.to_sym, is_maximized: true, is_single: true, observation_type: nil }
      ]

      get :graph_data, format: :json, session: valid_session
      expect(session[:launch_config][:components]).to eq(expected_component)
      expect(session[:launch_config][:time_range]).to eq(GRAPH_CONFIG['date_range']['default'].to_sym)
    end

    it 'parses passed in data when cerrner_srg is filled' do
      expected_output = [
        { component_type: 'MED'.to_sym, is_maximized: true, is_single: true, observation_type: nil },
        { component_type: 'OBS'.to_sym, is_maximized: true, is_single: true, observation_type: 'BP'.to_sym }
      ]

      valid_session['token_response']['cerrner_srg'] = '-t2Y MED.M OBS.BP.M.s'
      get :graph_data, format: :json, session: valid_session
      expect(session[:launch_config][:components]).to eq(expected_output)
      expect(session[:launch_config][:time_range]).to eq('2Y'.to_sym)
    end

    it 'combines default time settings and passed in data when cerrner_srg is missing time values' do
      expected_components = [
        { component_type: 'MED'.to_sym, is_maximized: true, is_single: true, observation_type: nil },
        { component_type: 'OBS'.to_sym, is_maximized: true, is_single: true, observation_type: 'BP'.to_sym }
      ]

      valid_session['token_response']['cerrner_srg'] = 'MED.M OBS.BP.M.s'
      get :graph_data, format: :json, session: valid_session

      expect(session[:launch_config][:components]).to eq(expected_components)
      expect(session[:launch_config][:time_range]).to eq(GRAPH_CONFIG['date_range']['default'].to_sym)
    end

    it 'combines default component settings and passed in time settings when cerrner_srg is missing component values' do
      expected_components = [
        { component_type: 'OBS'.to_sym, is_maximized: true, is_single: false, observation_type: 'BP'.to_sym },
        { component_type: 'MED'.to_sym, is_maximized: true, is_single: true, observation_type: nil }
      ]

      valid_session['token_response']['cerrner_srg'] = '-t1Y'
      get :graph_data, format: :json, session: valid_session
      expect(session[:launch_config][:components]).to eq(expected_components)
      expect(session[:launch_config][:time_range]).to eq('1Y'.to_sym)
    end

    it 'returns if session[:launch_config_raw] == cerrner_srg' do
      existing_launch_config = [
        time_range: '1Y'.to_sym,
        components: [
          { component_type: 'OBS'.to_sym, is_maximized: true, is_single: false, observation_type: 'BP'.to_sym },
          { component_type: 'MED'.to_sym, is_maximized: true, is_single: true, observation_type: nil }
        ]
      ]

      valid_session['launch_config'] = existing_launch_config
      valid_session['launch_config_raw'] = '-t1Y'
      valid_session['token_response']['cerrner_srg'] = '-t1Y'

      expect_any_instance_of(GraphsController).not_to receive(:global_parse)
      expect_any_instance_of(GraphsController).not_to receive(:component_parse)

      get :graph_data, format: :json, session: valid_session
    end
    it 'does not exit early if session[:launch_config_raw] != cerrner_srg' do
      existing_launch_config = [
        time_range: '2Y'.to_sym,
        components: [
          { component_type: 'OBS'.to_sym, is_maximized: true, is_single: false, observation_type: 'BP'.to_sym },
          { component_type: 'MED'.to_sym, is_maximized: true, is_single: true, observation_type: nil }
        ]
      ]

      valid_session['launch_config'] = existing_launch_config
      valid_session['launch_config_raw'] = '-t2Y'
      valid_session['token_response']['cerrner_srg'] = '-t1Y'

      get :graph_data, format: :json, session: valid_session
      expect(session[:launch_config][:time_range]).to eq('1Y'.to_sym)
    end
  end
  context 'FhirServices::Observation' do
    let(:valid_session_json) { JSON.parse(File.read(Rails.root.join('spec/fixtures/sessions/valid_session.json'))) }
    let(:valid_session) { valid_session_json.with_indifferent_access }

    before(:each) do
      valid_session[:token_response][:created_at] = Time.now
      allow_any_instance_of(GraphsController)
        .to receive(:fhir_service_observation_call)
        .and_return(FactoryBot.build_list(:observation, 2))
      get :graph_data, format: :json, session: valid_session
    end
    it 'renders success status 200 with correct attributes' do
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(response_body[0]['date']).to match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z/)
      expect(response_body[0]).to include('systolic' => a_kind_of(Float))
      expect(response_body[0]).to include('diastolic' => a_kind_of(Float))
      expect(response_body[0]).to include('sLow' => a_kind_of(Float))
      expect(response_body[0]).to include('sHigh' => a_kind_of(Float))
    end
  end
end
