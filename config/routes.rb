Rails.application.routes.draw do
  resources :messages, only: %i[ create show index new ]
  resources :chats

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  namespace :admin do
    resources :articles

    root to: "articles#index"
  end

  namespace :active_storage do
    resources :blobs, only: [] do
      post :pdf_callback, on: :member
    end
  end

  namespace :rails do
    namespace :active_storage do
      post "/blobs/:id/pdf_callback" => "blobs#pdf_callback", as: :blob_pdf_callback
    end
  end
  resources :contents, only: %i[ index show ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "contents#index"
end
