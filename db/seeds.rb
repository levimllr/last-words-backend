# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'benchmark'
require 'csv'
require 'byebug'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# reads dictionary.csv file and saves it as an array of arrays
# csv = CSV.read('./db/dictionary.csv')

# # returns point value of word based on scrabble letter values
# def points(word)
#   scrabble_points = {
#     "a" => 1,
#     "b" => 3,
#     "c" => 3,
#     "d" => 2,
#     "e" => 1,
#     "f" => 4,
#     "g" => 2,
#     "h" => 4,
#     "i" => 1,
#     "j" => 8,
#     "k" => 5,
#     "l" => 1,
#     "m" => 3,
#     "n" => 1,
#     "o" => 1,
#     "p" => 3,
#     "q" => 10,
#     "r" => 1,
#     "s" => 1,
#     "t" => 1,
#     "u" => 1,
#     "v" => 4,
#     "w" => 4,
#     "x" => 8,
#     "y" => 4,
#     "z" => 10
#   }
#   characters = word.downcase.split("")
#   characters.reduce(0) do |sum, char|
#     if scrabble_points[char]
#       sum + scrabble_points[char]
#     else
#       sum
#     end
#   end
# end

# inserts a new word for each entry of the csv file
# csv.each do |entry|
#   word_points = points(entry[0])
#   Word.create(
#     name: entry[0].downcase,
#     major_class: entry[1],
#     definition: entry[2].downcase,
#     points: word_points
#   )
# end

# create new games, and simulate a game
alphabet = Array('a'..'z')
alphabet_capitalized = Array('A'..'Z')
guess_type = ["cheat", "lucky guess", "blind guess"]
10.times do
  game_name_array = []
  3.times do
    game_name_array << alphabet_capitalized.sample
  end
  game_name = game_name_array.join("")

  new_game = Game.create(username: game_name)
  lost = false

  while lost == false
    new_word = Word.all.sample
    game_word = GameWord.new()
    game_word.game = new_game
    game_word.word = new_word
    unique_word_characters = game_word.word.name.split("").uniq
    misses = []
    hits = []

    until misses.length == 5 || hits.length == unique_word_characters.length
      if guess_type.sample == "blind guess"
        letter = alphabet.sample
      else
        letter = unique_word_characters.sample
      end
      
      if unique_word_characters.include?(letter)
        hits << letter
      else
        misses << letter
      end
    end

    if misses.length == 5
      lost = true
      game_word.win = false
    else
      score = (new_word.points + new_word.name.length) - (2 * misses.length)
      game_word.score = score
      new_total_score = new_game.total_score + score
      new_game.update(total_score: new_total_score)
      game_word.win = true
    end

    game_word.misses = misses.join("")
    game_word.save
  end
end
