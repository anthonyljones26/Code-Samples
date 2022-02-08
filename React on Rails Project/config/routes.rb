Rails.application.routes.draw do
  root 'refill#index'
  resources :users, only: :update
  resources :refill, only: [:index, :create]

  post 'refresh-token', to: 'auth#refresh_token'
  match 'no-relationship', to: 'application#render_no_relationship', via: :all, as: 'no_relationship'

  if Rails.env.test? || Rails.env.development?
    mount Portal::DexFrameworkMock::Engine => '/dex-framework/', as: :dex_framework
  end

  # Custom error pages
  match '401', to: 'application#render_unauthorized', via: :all, as: 'unauthorized'
  match '403', to: 'application#render_forbidden', via: :all, as: 'forbidden'
  match '404', to: 'application#render_not_found', via: :all, as: 'not_found'
  match '500', to: 'application#render_internal_server_error', via: :all, as: 'internal_server_error'

  # Leave this as the last route entry
  match '*unmatched_route', to: 'application#render_not_found', via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
