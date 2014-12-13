require 'sidekiq/web'
Rails.application.routes.draw do
  root 'places#index'

  resources :places, only: [:show, :index]
  
  mount Sidekiq::Web, at: '/sidekiq'
end
