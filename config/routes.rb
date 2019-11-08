Rails.application.routes.draw do
  resources :games, only: [:create, :update] do
    resources :game_words, only: [:create]
  end
  get '/random_words', to: "words#random_words"
  get '/games/high_scores', to: "games#high_scores"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
