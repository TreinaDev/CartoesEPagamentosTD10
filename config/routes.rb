Rails.application.routes.draw do
  devise_for :admins
  root "home#index"
  resources :card_types, only: [:index, :new, :create, :show, :edit, :update] do
    patch 'enable', on: :member
    patch 'disable', on: :member
  end
end
