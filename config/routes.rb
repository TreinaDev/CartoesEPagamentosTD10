Rails.application.routes.draw do
  devise_for :admins
  root "home#index"

  namespace :api do
    namespace :v1 do
      resources :company_card_types, only: [:index]
      resources :cards, only: [:create]
    end
  end
  resources :card_types, only: [:index, :new, :create, :show, :edit, :update]
end
