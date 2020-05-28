Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      member { patch :set_best }
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
