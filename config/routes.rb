Rails.application.routes.draw do
  get 'vendors/index'

  get 'vendors/new'

  get 'vendors/create'

  get 'vendors/show'

  resources :vendors

  devise_for :users
  root 'pages#index'
  get '/dashboard', to: 'pages#dashboard', as: 'dashboard'

  resources :properties

  resources :customers do
    resources :payments
    resources :invoices
  end
  get '/customers/archive/:id', to: 'customers#archive', as: 'archive_customer'

  resources :accounts
  resources :checks
  resources :deposits

  get '/register', to: 'register#index', as: 'register'
end
