class WordsController < ApplicationController
  def random_word
    word = Word.all.sample
    render(json: word)
  end
end
