Rails.application.routes.draw do
  # Challenge routes
  get '/challenges' => 'challenges#index'
  get '/challenges/weekly' => 'challenges#weekly'
  get '/challenges/monthly' => 'challenges#monthly'

  # Admin routes
  namespace :admin do
    root 'dashboard#index'
    get 'dashboard' => 'dashboard#index'

    # Database management endpoints
    get 'database/status' => 'database#status'
    post 'database/import' => 'database#import'

    resources :products do
      member do
        post :approve
        post :reject
        post :toggle_featured
      end
    end
    resources :users do
      member do
        post :toggle_role
      end
    end
    resources :topics
  end

  # Search routes
  get '/search' => 'search#index'
  get '/search/suggestions' => 'search#suggestions'
  get '/my' => 'users#show'
  get '/my/edit' => 'users#edit'
  patch '/my' => 'users#update'
  get '/collections' => 'collections#index'
  get '/community' => 'community#index'
  root "home#index"
  
  # Authentication routes
  get '/login' => 'sessions#new'
  post '/auth/kakao_test' => 'sessions#kakao_login'
  post '/auth/google_test' => 'sessions#google_login'
  get '/auth/:provider/callback' => 'sessions#omniauth_callback'
  delete '/logout' => 'sessions#destroy'

  # Rankboard routes
  get '/rankboard' => 'leaderboards#daily'
  get '/rankboard/daily' => 'leaderboards#daily'
  get '/rankboard/daily/:year/:month/:day' => 'leaderboards#daily_date'
  get '/rankboard/weekly' => 'leaderboards#weekly'
  get '/rankboard/monthly' => 'leaderboards#monthly'
  get '/rankboard/yearly' => 'leaderboards#yearly'
  get '/rankboard/all' => 'leaderboards#all_time'
  
  # Legacy leaderboard redirects
  get '/leaderboard' => redirect('/rankboard')
  get '/leaderboard/daily' => redirect('/rankboard/daily')
  get '/leaderboard/daily/:year/:month/:day' => redirect('/rankboard/daily/%{year}/%{month}/%{day}')
  get '/leaderboard/weekly' => redirect('/rankboard/weekly')
  get '/leaderboard/monthly' => redirect('/rankboard/monthly')
  get '/leaderboard/yearly' => redirect('/rankboard/yearly')
  
  resources :products do
    member do
      post :vote
      delete :unvote
    end
    resources :comments, except: [:index, :show]
    resources :reviews do
      member do
        post :helpful
      end
      resources :replies, except: [:show]
    end
    resources :likes, only: [:create, :destroy]
  end
  
  resources :topics do
    resources :products, only: [:index]
  end
  
  resources :collections
  resources :users, only: [:show, :edit, :update] do
    collection do
      get :search
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
