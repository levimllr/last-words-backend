class GamesController < ApplicationController
  def create
    new_game = Game.create(username: params[:username])
    render(json: new_game)
  end

  def update
    current_game = Game.find(params[:id])
    current_game.update(total_score: params[:total_score])
  end

  def high_scores
    ten_highest_scores = Game.high_scores
    render(json: ten_highest_scores)
  end
end
