Rails.application.routes.draw do
  devise_for :admins
  root "home#index"

  namespace :api do
    namespace :v1 do
      resources :company_card_types, only: [:index]
    end
  end
end
