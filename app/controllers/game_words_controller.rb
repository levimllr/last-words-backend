class GameWordsController < ApplicationController
  def create
    # byebug
    new_game_word = GameWord.new(
      game_id: params["game_word"]["game_id"],
      word_id: params["game_word"]["word_id"],
      misses: params["game_word"]["misses"],
      win: params["game_word"]["win"]
    )
    new_game_word.score = new_game_word.calculate_score
    new_game_word.save
    render(json: new_game_word)
  end

  # private

  # def game_words_params
  #   params.require(:game_words).permit(:game_id, :word_id, :score, :misses, :win)
  # end
end
