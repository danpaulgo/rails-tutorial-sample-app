Rails.application.routes.draw do

  get 'users/new'

  root 'static_pages#home'
  get 'home', to: 'static_pages#home'
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'
  get 'signup', to: 'users#new'
  get 'help',  to: 'static_pages#help', as: "helping"
  # SAME AS
  # get("help", {to: "static_pages#contact"})

  # OLD HELP PATH:
  # get 'static_pages/help'
  # Does not require "to:" because the requested path is the same as the actual path

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'static_pages#home'
end
