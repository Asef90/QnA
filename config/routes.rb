require 'sidekiq/web'

Rails.application.routes.draw do
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

  concern :commentable do
    member { post :create_comment }
  end

  concern :subscriptable do
    member do
      patch :subscribe
      patch :unsubscribe
    end
  end

  resources :questions, concerns: [:commentable, :subscriptable, :votable]  do
    resources :answers, shallow: true, concerns: [:commentable, :votable] do
      member do
        patch :set_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index


  mount ActionCable.server, at: '/cable'
end
