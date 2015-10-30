Rails.application.routes.draw do
  root 'users#index'

  resources :users
  resources :matches do
    get 'refresh', on: :member
    get 'join', on: :member
    get 'start', on: :member
  end

  get 'lobby' => 'matches#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
end
