Rails.application.routes.draw do
  resources :lwin_identifiers, only: [ :index, :show ]

  resources :producers, only: [ :index, :show ] do
    resources :wines, shallow: true, only: [ :index ]
  end

  resources :classifications, only: [ :index, :show ]

  resources :locations, only: [ :index, :show ] do
    resources :locations, shallow: true, only: [ :index ]
    resources :wines, shallow: true, only: [ :index ]
  end

  resources :wines, only: [ :index, :show ]

  root to: 'pages#index'
end
