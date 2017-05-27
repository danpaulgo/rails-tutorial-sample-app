Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  # get '/account_activation/:token/edit', to: 'account_activations#edit'
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  # get 'sessions/new' # to: sessions#new
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  post 'signup', to: 'users#create'
  get 'signup', to: 'users#new'

  resources :microposts, only: [:create, :edit, :update, :destroy]

  root 'static_pages#home'
  get 'home', to: 'static_pages#home'
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'
  get 'help',  to: 'static_pages#help', as: "helping"
  # SAME AS
  # get("help", {to: "static_pages#contact"})

  # OLD HELP PATH:
  # get 'static_pages/help'
  # Does not require "to:" because the requested path is the same as the actual path

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'static_pages#home'
end
