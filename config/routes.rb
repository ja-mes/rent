Rails.application.routes.draw do
  resources :registers
  resources :reconciliations
  resources :recurring_trans
  resources :vendors

  devise_for :users
  root 'pages#index'
  get '/dashboard', to: 'dashboard#index', as: 'dashboard'
  get '/dashboard/charge_rent', to: 'dashboard#charge_rent', as: 'charge_rent'
  get '/dashboard/enter_recurring_trans', to: 'dashboard#enter_recurring_trans', as: 'enter_recurring_trans'

  resources :properties

  resources :customers do
    get 'blank', on: :new
    resources :payments do
      get 'receipt', on: :member
    end

    resources :invoices
    resources :credits
    resources :notes
  end
  get '/customers/archive/:id', to: 'customers#archive', as: 'archive_customer'


  resources :accounts
  resources :checks
  resources :deposits

  get '/register', to: 'register#index', as: 'check_register'

  mount Resque::Server.new, :at => '/resque'
end
