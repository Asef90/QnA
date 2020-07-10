require 'sidekiq/web'

Rails.application.routes.draw do
  get 'search/index'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'

  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, shallow: true, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: :oauth_callbacks }

  namespace :authorizations do
    get :confirmation
    patch :handle
    get :confirm
  end

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, concerns: [:votable]  do
    resources :answers, shallow: true, concerns: [:votable] do
      resources :comments, shallow: true, only: [:create], defaults: { commentable: 'answers'}

      member { patch :set_best }
    end

    resources :comments, shallow: true, only: [:create], defaults: { commentable: 'questions'}

    resources :subscriptions, shallow: true, only: [:create, :destroy],
                              defaults: { subscriptable: 'questions'}
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  get '/search', to: 'search#index'

  mount ActionCable.server, at: '/cable'
end
