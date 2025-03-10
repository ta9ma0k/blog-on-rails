Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations:  "users/registrations"
  }, skip: [:registrations]
  devise_scope :user do
    get "sign_up", to: "users/registrations#new", as: :new_user
    post "users", to: "users/registrations#create", as: :users
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "posts#index"

  scope :users do
    get ":username", to: "users#profile", as: "profile"

    resources :followees, only: %i[create]
  end

  resources :posts, only: %i[create] do
    resources :likes, only: %i[create]
    resources :comments, only: %i[create]
  end
end
