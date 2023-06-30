Rails.application.routes.draw do
  devise_for :admins
  root "home#index"

  resources :companies, only: [:show, :index] do
    get 'search', on: :collection
  end
  resources :company_card_types, only: [:create, :update] do
    patch 'enable', on: :member
    patch 'disable', on: :member
  end

  resources :card_types, only: [:index, :new, :create, :show, :edit, :update] do
    patch 'enable', on: :member
    patch 'disable', on: :member
  end

  resources :payments, only: [] do
    get 'search_pending', on: :collection
    get 'search_ended', on: :collection
    patch 'approve', on: :member
    patch 'reprove', on: :member
    get 'pending', on: :collection
    get 'finished', on: :collection
  end

  resources :cashback_rules, only: [:index, :new, :create, :edit, :update]

  namespace :api do
    namespace :v1 do
      resources :company_card_types, only: [:index]
      resources :extracts, only: [:index]
      resources :payments, only: [:create, :show] do
        get 'by_cpf', on: :collection, to: 'payments#all_by_cpf'
      end
      resources :cards, only: [:create, :destroy, :show] do
        delete 'block', on: :member
        patch 'activate', on: :member
        patch 'deactivate', on: :member
        post 'upgrade', on: :collection
        patch 'recharge', on: :collection, to: 'recharges#update'
      end
    end
  end
end
