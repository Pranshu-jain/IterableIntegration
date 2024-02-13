Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users


  resources :events do
    member do
      post 'create_event_a'
      post 'create_event_b'
    end
  end
  
  root 'events#index'
  # Defines the root path route ("/")
  # root "articles#index"
end
