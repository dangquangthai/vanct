# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'dashboard#index'
  get  'dashboard/:table_no' => 'dashboard#show', as: :dashboard_show
  get  '/report' => 'report#index', as: :report_index

  namespace :admin do
    resources :customers do
      resources :users
    end
  end

  namespace :api do
    namespace :v1 do
      get  'info' => 'info#show'
      post 'live' => 'live#create'
      post 'sync' => 'sync#create'
    end
  end
end
