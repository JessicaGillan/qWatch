Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'angular#index'

  scope :api do
    scope :v1 do
      resources :search, only: [:index]
      resources :watch, only: [:index, :show]
      resources :tmdb_config, only: [:index]

      devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations',
        omniauth_callbacks: 'users/omniauth_callbacks'
      }
    end
  end
end
