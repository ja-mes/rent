Rails.application.routes.draw do
  resources :vendors

  devise_for :users
  root 'pages#index'
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  get '/dashboard/charge_rent', to: 'dashboard#charge_rent', as: 'charge_rent'

  resources :properties

  resources :customers do
    resources :payments
    resources :invoices
    resources :credits
    resources :notes
  end
  get '/customers/archive/:id', to: 'customers#archive', as: 'archive_customer'


  resources :accounts
  resources :checks
  resources :deposits

  get '/register', to: 'register#index', as: 'register'

  mount Resque::Server.new, :at => '/resque'
end
