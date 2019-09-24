require 'sidekiq/web'
require 'api_constraints'

Sidekiq::Web.set :sessions, false

Rails.application.routes.draw do

  # authenticate :user do#, lambda { |u| u.is_owner? }
  mount Sidekiq::Web => '/bg'
  # end

  root to: 'welcome#index'
  authenticated :user do
    root to: "businesses#index"
  end

  devise_for :users

  concern :transactions do
    get :transactions, on: :member
  end

  resources :businesses, concerns: :transactions do
    resources :plans
    resources :coupons
    resources :subscriptions, concerns: :transactions
    resources :invoices, concerns: :transactions, only: [:index, :show]
    resources :customers, concerns: :transactions, except: [:destroy]
  end

  match 'orta/ipn', to: 'payment_callbacks#ipn', via: [:get, :post]

  #######API ROUTES######################################################################

  namespace :api, defaults: {format: :json} do
    resources :plans
    resources :coupons
    resources :customers
    resources :subscriptions do
      get :status, on: :member
    end
    root to: 'dashboards#welcome'
  end
end
