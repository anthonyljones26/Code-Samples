Rails.application.routes.draw do
  root 'graphs#index'
  get 'graph_data', to: 'graphs#graph_data'
  get 'med_graph_data', to: 'medications#graph_data'
  resource :logs, only: [:create]
  resources :keep_alive, only: :index

  mount Fhir::AuthEngine::Engine, at: '/auth', as: 'fhir_auth'

  if Rails.env.test? || Rails.env.development?
    get 'mock_session', to: 'mock_session#index'
    get 'mock_session/set', to: 'mock_session#set', as: 'mock_session_set'
  end

  if Rails.env.development?
    require 'mr_video'
    mount MrVideo::Engine => '/mr_video'
  end
end
