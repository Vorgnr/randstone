Rails.application.routes.draw do
  devise_for :users
  resources :users do
    get '/cards', to: 'users#cards'
    post '/add_card', to: 'users#add_card'
    post '/delete_card', to: 'users#delete_card'
  end

  resources :decks
  post 'decks/new/add_opponent', to: 'decks#add_opponent'
  post 'decks/new/add_hero', to: 'decks#add_hero'
  post 'decks/new/add_card', to: 'decks#add_card'
end
