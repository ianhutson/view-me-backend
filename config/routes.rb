Rails.application.routes.draw do
  resources :auctions
  resources :bids
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'
end
