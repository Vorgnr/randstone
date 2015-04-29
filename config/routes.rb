Rails.application.routes.draw do
  root 'users#index'
  devise_for :users
  resources :users
  resources :decks
  
  post 'decks/new/add_opponent', to: 'decks#add_opponent'
  post 'decks/new/add_hero', to: 'decks#add_hero'
  post 'decks/new/add_card', to: 'decks#add_card'
  get '/my-collection', to: 'users#cards'
  post '/add_card', to: 'users#add_card'
  post '/delete_card', to: 'users#delete_card'
  post '/add_all_once', to: 'users#add_all_once'
  post '/remove_all', to: 'users#remove_all'
  post '/get_cards', to: 'users#get_cards', default: { format: :json }
end
