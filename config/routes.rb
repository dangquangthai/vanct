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
  get  '/report/download_csv' => 'report#download_csv', as: :report_download_csv

  get  '/current_user' => 'current_user#show', as: :current_user_show
  patch '/current_user/change_password' => 'current_user#change_password', as: :current_user_change_password

  get '/expired' => 'expired#index', as: :expired

  namespace :admin do
    resources :customers do
      resources :users
      member do
        post :queue_insert_to_desktop
      end
    end
    resources :settings, only: %i[index edit update]
    resources :products, only: %i[index edit update]
  end

  namespace :api do
    namespace :v1 do
      resources :info, only: %i[index]
      resources :live, only: %i[create]

      # for the old version
      post 'sync' => 'sync_shift#create'
      resources :sync_shift, only: %i[create]

      resources :sync_vouchers, only: %i[create]
      resources :sync_products, only: %i[create]
      resources :sync_inventories, only: %i[create]
    end
  end
end
