Rails.application.routes.draw do
  resources :lwin_identifiers, only: [ :index, :show ]
  resources :producers, only: [ :index, :show ]
  resources :classifications, only: [ :index, :show ]
  resources :locations, only: [ :index, :show ]

  root to: 'pages#index'
end
