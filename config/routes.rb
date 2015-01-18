Rails.application.routes.draw do
  resources :lwin_identifiers, only: [ :index, :show ]

  root to: 'pages#index'
end
