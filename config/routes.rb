Rails.application.routes.draw do
  devise_for :admins
  root "home#index"

  namespace :api do
    namespace :v1 do
      resources :company_card_types, only: [:index]
      # get 'company_card_types/:cnpj' to: 'company_card_types#index'
    end
  end
end
