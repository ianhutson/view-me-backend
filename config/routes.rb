Rails.application.routes.draw do
  resources :auctions
  resources :bids
  resources :users
  get '/current_user', to: 'sessions#show', via: [:get]
  match '/auth/twitch/callback', to: 'sessions#create', via: [:get]
end
