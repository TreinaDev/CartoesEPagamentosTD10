Rails.application.routes.draw do
  devise_for :admins
  root "home#index"

  resources :companies, only: [:show, :index]
  resources :company_card_types, only: [:create, :update] do
    patch 'enable', on: :member
    patch 'disable', on: :member
  end

  resources :card_types, only: [:index, :new, :create, :show, :edit, :update] do
    patch 'enable', on: :member
    patch 'disable', on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :company_card_types, only: [:index]
      resources :cards, only: [:create, :update] do
        delete 'block', on: :member
      end
    end
  end
end
