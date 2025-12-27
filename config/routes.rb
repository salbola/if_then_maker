Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "pages#landing_page"
  resources :dash_boards, only: [ :index ]
  # 新規登録機能->users
  resources :users, only: [ :new, :create ]
  # ログイン,ログアウト機能->user_sessions
  get  "/login",  to: "user_sessions#new"
  post "/login",  to: "user_sessions#create"
  delete "/logout", to: "user_sessions#destroy"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
