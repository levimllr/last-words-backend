class Word < ApplicationRecord
  # return a random word to the client in json format
  def random_word
    word = Word.all.sample

    render(json: word)
  end
end
