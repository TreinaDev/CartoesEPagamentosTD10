Rails.application.routes.draw do
  devise_for :admins
  root "home#index"

  resources :companies, only: [:show, :index]
  resources :card_types, only: [:index, :new, :create, :show, :edit, :update]
  resources :company_card_types, only: [:create, :update]
end
