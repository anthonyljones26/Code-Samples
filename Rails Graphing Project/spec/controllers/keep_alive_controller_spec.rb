require 'rails_helper'
require 'json'

RSpec.describe KeepAliveController, type: :controller do
  context 'when unauthorized' do
    before(:each) do
      allow_any_instance_of(FhirServices::Client).to receive(:reauthorize).and_return(false)
      get :index, format: :json, session: {
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

    it 'returns render_unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when authorized' do
    before(:each) do
      allow_any_instance_of(FhirServices::Client).to receive(:reauthorize).and_return(true)
      get :index, format: :json, session: {
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

    it 'returns render_ok' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['expireTime']).to match(
        /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3,}[-+]\d{2}:\d{2}$/
      )
    end
  end
end
