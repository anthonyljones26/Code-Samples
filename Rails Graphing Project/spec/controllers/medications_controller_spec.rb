require 'rails_helper'

RSpec.describe MedicationsController, type: :controller do
  context 'when FhirServices::Client error' do
    before(:each) do
      allow_any_instance_of(FhirServices::Client)
        .to receive(:retrieve_medication_statements_by_patient)
        .and_raise('retrieve_medication_statements_by_patient error')

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
      expect(response.body).to eq('{"error":"retrieve_medication_statements_by_patient error"}')
    end
  end

  context 'when FhirServices::Client success' do
    let(:valid_session_json) { JSON.parse(File.read(Rails.root.join('spec/fixtures/sessions/valid_session.json'))) }
    let(:valid_session) { valid_session_json.with_indifferent_access }

    before(:each) do
      valid_session[:token_response][:created_at] = Time.now

      allow_any_instance_of(MedicationsController)
        .to receive(:retrieve_medication_statements)
        .and_return(FactoryBot.build_list(:medication_statement, 2))
      allow_any_instance_of(MedicationsController)
        .to receive(:retrieve_medication_orders)
        .and_return(FactoryBot.build_list(:medication_order, 2))
      get :graph_data, format: :json, session: valid_session
    end

    it 'renders success status 200' do
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
      expect(response.body).to match('strength')
      expect(response.body).to match('quantity')
      expect(response.body).to match('additionalInstructions')
    end
  end
end
