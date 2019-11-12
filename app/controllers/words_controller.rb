class WordsController < ApplicationController
  def random_words
    count = (params[:count] || "20").to_i
    points = params[:points]
    if points
      words = Word.all.where("points > #{points}").sample(count)
    else
      words = Word.all.sample(count)
    end
    render(json: words)
  end
end
