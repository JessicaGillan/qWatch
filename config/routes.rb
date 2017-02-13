Rails.application.routes.draw do
  get 'watchables/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'angular#index'

  scope :api do
    scope :v1 do
      resources :search, only: [:index]
      resources :watch, only: [:index, :show]
    end
  end
end
