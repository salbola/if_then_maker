Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "pages#landing_page"
  get  "/about",  to: "pages#about"
  get  "/term",  to: "pages#term"
  get  "/privacy",  to: "pages#privacy"
  resources :dash_boards, only: [ :index ]
  # 新規登録機能->users
  resources :users, only: [ :new, :create ]
  # ログイン,ログアウト機能->user_sessions
  get  "/login",  to: "user_sessions#new"
  post "/login",  to: "user_sessions#create"
  delete "/logout", to: "user_sessions#destroy"
  # メモの機能->memos
  resources :memos
  # ifthenの表示機能->if_then_rules
  resources :if_then_rules, only: %i[ index show new create edit update destroy] do
    resources :reflections, only: %i[create destroy]
  end
  # ifthenの作成機能(ステップUI)->if_then_rules/flows
  namespace :if_then_rules do
    resource :flow do
      get :step1
      # post :step1, action: :step1_submit
      # get :step2
      # post :step2, action: :step2_submit
      # get :step3
      # post :step3, action: :step3_submit
    end
  end
  # reflections 振り返りの表示機能
  resources :reflections, only: %i[index]
  resource :reflection_time, only: %i[update edit]


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
