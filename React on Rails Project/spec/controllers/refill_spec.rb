require 'rails_helper'

RSpec.describe RefillController, type: :controller do
  before { @session_data = JSON.parse(File.read(Rails.root.join('spec/fixtures/sessions/single_user_session.json'))) }

  describe 'POST #create' do
    render_views
    before(:each) do
      @create_params = {
        'patientIndex' => 0,
        'paymentMethod' => 'Insurance',
        'recentVisit' => true,
        'deliveryMethod' => 'pickup',
        'address' => {
          'streetAddress1' => '27 N 10th Street',
          'streetAddress2' => '',
          'city' => 'Columbia',
          'state' => 'MO',
          'zipcode' => '65201',
          'country' => ''
        }
      }
    end
    it 'returns http success' do
      allow(Portal::CareawareApi::Services::Millennium::Messages)
        .to receive(:create_message).and_return(status: 201, data: '')
      allow(Portal::HcoApi::Services::Visits)
        .to receive(:create_visit) { { adm_num: 201, vis_num: 201 } }
      post :create, format: 'json', session: @session_data, params: { refill: @create_params }
      expect(response).to have_http_status(:created)
    end

    it 'returns 422 if missing data sent to CareawareApi' do
      allow(Portal::CareawareApi::Model::Millennium::Message)
        .to receive(:new).and_return(Portal::CareawareApi::Model::Millennium::Message.new)
      allow(Portal::HcoApi::Services::Visits)
        .to receive(:create_visit) { { adm_num: 201, vis_num: 201 } }
      post :create, format: 'json', session: @session_data, params: { refill: @create_params }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    context 'Returns 500 error' do
      it 'for all errors except 422 from CareawareApi' do
        allow(Portal::CareawareApi::Services::Millennium::Messages)
          .to receive(:create_message).and_raise(Portal::CareawareApi::Services::Errors::InternalServerError)
        allow(Portal::HcoApi::Services::Visits)
          .to receive(:create_visit) { { adm_num: 201, vis_num: 201 } }
        post :create, format: 'json', session: @session_data, params: { refill: @create_params }
        expect(response).to have_http_status(:internal_server_error)
      end
    end

    context 'Invaid Params' do
      context 'patientIndex' do
        it 'should return 422 if missing' do
          @create_params.delete('patientIndex')
          post :create, format: 'json', session: @session_data, params: { refill: @create_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return 422 if different from session user' do
          @create_params['patientIndex'] = 1
          post :create, format: 'json', session: @session_data, params: { refill: @create_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'paymentMethod' do
        it 'should return 422 if missing' do
          @create_params.delete('paymentMethod')
          post :create, format: 'json', session: @session_data, params: { refill: @create_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return 422 if empty string' do
          @create_params['paymentMethod'] = ''
          post :create, format: 'json', session: @session_data, params: { refill: @create_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'recentVisit' do
        it 'should return 422 if missing' do
          @create_params.delete('recentVisit')
          post :create, format: 'json', session: @session_data, params: { refill: @create_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'deliveryMethod' do
        it 'should return 422 if missing' do
          @create_params.delete('deliveryMethod')
          post :create, format: 'json', session: @session_data, params: { refill: @create_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return 422 if empty string' do
          @create_params['deliveryMethod'] = ''
          post :create, format: 'json', session: @session_data, params: { refill: @create_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'address' do
        it 'should return 422 if missing' do
          @create_params.delete('address')
          post :create, format: 'json', session: @session_data, params: { refill: @create_params }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        context 'streetAddress1' do
          it 'should return 422 if missing' do
            @create_params['address'].delete('streetAddress1')
            post :create, format: 'json', session: @session_data, params: { refill: @create_params }
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'should return 422 if empty string' do
            @create_params['address']['streetAddress1'] = ''
            post :create, format: 'json', session: @session_data, params: { refill: @create_params }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'city' do
          it 'should return 422 if missing' do
            @create_params['address'].delete('city')
            post :create, format: 'json', session: @session_data, params: { refill: @create_params }
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'should return 422 if empty string' do
            @create_params['address']['city'] = ''
            post :create, format: 'json', session: @session_data, params: { refill: @create_params }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'state' do
          it 'should return 422 if missing' do
            @create_params['address'].delete('state')
            post :create, format: 'json', session: @session_data, params: { refill: @create_params }
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'should return 422 if empty string' do
            @create_params['address']['state'] = ''
            post :create, format: 'json', session: @session_data, params: { refill: @create_params }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end

        context 'zipcode' do
          it 'should return 422 if missing' do
            @create_params['address'].delete('zipcode')
            post :create, format: 'json', session: @session_data, params: { refill: @create_params }
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it 'should return 422 if empty string' do
            @create_params['address']['zipcode'] = ''
            post :create, format: 'json', session: @session_data, params: { refill: @create_params }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end
end
