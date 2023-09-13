Rails.application.routes.draw do
  root "static_pages#home"
  get "static_pages/home"

  resources :products

  get 'cart/index'

  get "/login", to: "session#new"
  post "/login", to: "session#create"
  delete "/logout", to: "session#destroy"
end
