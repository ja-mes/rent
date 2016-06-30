Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # SETTINGS
  get '/settings', to: 'settings#index', as: 'settings'
  post '/settings/update_checkbook', to: 'settings#update_checkbook_balance', as: 'settings_update_checkbook'

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

  mount Resque::Server.new, :at => '/resque'
end
