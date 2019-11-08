Rails.application.routes.draw do
  resources :games, only: [:create, :update] do
    resources :game_words, only: [:create]
  end
  get '/random_word', to: "words#random_word"
  get '/games/high_scores', to: "games#high_scores"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
