Rails.application.routes.draw do
  root "static_pages#home"
  get "static_pages/home"

  resources :products

  get "/login", to: "session#new"
  post "/login", to: "session#create"
  delete "/logout", to: "session#destroy"

  resources :cart, only: :index
  get "/add_to_cart", to: "cart#add_to_cart"
end
