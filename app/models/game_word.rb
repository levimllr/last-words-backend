class GameWord < ApplicationRecord
  belongs_to :game 
  belongs_to :word

  def calculate_score
    self.word.points + self.word.name.length - (2 * self.misses.length)
  end

end
