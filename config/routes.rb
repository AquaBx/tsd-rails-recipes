Rails.application.routes.draw do
  resources :ingredients
  resources :ingredients, only: :create
  resources :recipes
  devise_for :users
  root "hello#index"
end
