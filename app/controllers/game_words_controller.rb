class GameWordsController < ApplicationController
  def create
    GameWord.create(game_words_params)
  end

  private

  def game_words_params
    params.require(:game_words).permit(:game_id, :word_id, :misses, :win)
  end 
end
