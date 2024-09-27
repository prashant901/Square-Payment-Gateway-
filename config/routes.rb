Rails.application.routes.draw do
  root 'customers#new'
  resources :customers, only: [:new, :create]
  resources :payments, only: [:new, :create]
  resources :orders, only: [:new, :create]


end
