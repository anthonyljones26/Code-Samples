require 'rails_helper'

RSpec.describe LogsController, type: :controller do
  describe 'POST #create' do
    let(:create_params) do
      {
        'EventDomain' => 'GraphSelectors',
        'EventType' => 'ResultType',
        'Description' => 'Clicked'
      }
    end

    it 'returns http success' do
      allow_any_instance_of(ResultsGraphingFhir::Logger)
        .to receive(:log_user_event).and_return(nil)
      post :create, format: 'json', session: @session_data, params: create_params
      expect(response).to have_http_status(:created)
      allow_any_instance_of(ResultsGraphingFhir::Logger).to receive(:log_user_event).and_call_original
    end
  end
end
