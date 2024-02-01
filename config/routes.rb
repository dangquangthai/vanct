# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'dashboard#index'
  get  'dashboard/show' => 'dashboard#show', as: :dashboard_show

  get  '/report' => 'report#index', as: :report_index
  get  '/report/show/:bill_id' => 'report#show', as: :report_show
  get  '/report/export/form' => 'report#export_form', as: :report_export_form
  post '/report/export' => 'report#export', as: :report_export
  get  '/report/download_csv' => 'report#download_csv', as: :report_download_csv

  get  '/current_user' => 'current_user#show', as: :current_user_show
  patch '/current_user/change_password' => 'current_user#change_password', as: :current_user_change_password

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
