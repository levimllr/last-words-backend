Rails.application.routes.draw do
  gets '/word_search', to: 'word#search'
  gets '/random_word', to: 'word#random'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
