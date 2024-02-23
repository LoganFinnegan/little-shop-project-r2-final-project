Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :admin, only: :index

  resources :merchants do 
    # resources :dashboard, as: "merchant_dashboard"
    member { get "dashboard" }
    resources :items, controller: 'merchant_items', only: :index
  end
  

  resources :invoices, controller: "merchant_invoices"

end
