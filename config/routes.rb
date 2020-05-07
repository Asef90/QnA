Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions, only: [:show, :new, :create] do
    resources :answers, only: [:show, :new, :create]
  end
end
