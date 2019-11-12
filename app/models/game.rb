class Game < ApplicationRecord
  has_many :game_words
  has_many :words, through: :game_words

  # returns the games with top 10 highest scores
  def self.high_scores
    self.order(total_score: :desc).first(10)
  end
end
