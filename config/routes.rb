Rails.application.routes.draw do
  devise_for :admins
  root "home#index"
  resources :card_types, only: [:new, :create, :show]
end
