Rails.application.routes.draw do
  resources :auctions
  resources :bids
  resources :users
  match '/auth/twitch/callback', to: 'sessions#create', via: [:get, :post]
end
