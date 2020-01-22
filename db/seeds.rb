# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require 'benchmark'
require 'csv'
# require 'byebug'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# reads dictionary.csv file and saves it as an array of arrays
csv = CSV.read('./db/dictionary.csv')

# returns point value of word based on scrabble letter values
def points(word)
  scrabble_points = {
    "a" => 1,
    "b" => 3,
    "c" => 3,
    "d" => 2,
    "e" => 1,
    "f" => 4,
    "g" => 2,
    "h" => 4,
    "i" => 1,
    "j" => 8,
    "k" => 5,
    "l" => 1,
    "m" => 3,
    "n" => 1,
    "o" => 1,
    "p" => 3,
    "q" => 10,
    "r" => 1,
    "s" => 1,
    "t" => 1,
    "u" => 1,
    "v" => 4,
    "w" => 4,
    "x" => 8,
    "y" => 4,
    "z" => 10
  }
  characters = word.downcase.split("")
  characters.reduce(0) do |sum, char|
    if scrabble_points[char]
      sum + scrabble_points[char]
    else
      sum
    end
  end
end

def definition_filter(defn)
  if defn.include?("; as")
    return defn.split("; as").first
  else
    return defn
  end
end

# inserts a new word for each entry of the csv file
last_word = ""
csv.each do |entry|
  word_name = entry[0].downcase
  word_pts = points(word_name)
  defn = definition_filter(entry[2].downcase)
  defn_array = defn.split(",").join("").split(".").join("").split(";").join("").split(" ")

  # words that are too short
  next if word_name.length < 4

  # no words with too short of definitions
  next if defn_array.length < 4

  # no words of the plural, preterite, interjection, superlative, prefix, or adverb classes
  next if entry[1].include?("p.") && entry[1] != "prep."
  next if entry[1] == ""
  next if entry[1].include?("pl.")
  next if entry[1].include?("interj.")
  next if entry[1].include?("superl.")
  next if entry[1].include?("prefix.")
  next if entry[1].include?("adv.")

  # no words with definitions that include or start with the following
  next if defn.include?("one who")
  next if defn.include?("alt.")
  next if defn.include?("genus")
  next if defn.include?("species")
  next if defn.include?("pertaining to")
  next if defn.include?("the quality of")
  next if defn_array[0] == "see"
  next if defn_array[0] == "same as"

  # no words that can be found in their definition
  next if defn_array.select { |defn_word| word_name.include?(defn_word) || defn_word.include?(word_name) } != []

  # no words that contain punctuation or space
  next if word_name.include?(" ")
  next if word_name.include?("'")
  next if word_name.include?("-")

  # update word with expanded definition if it already exists, otherwise create
  if last_word == entry[0]
    Word.last.update(definition: Word.last.definition + " " + entry[2].downcase)
  else
    Word.create(name: word_name, major_class: entry[1], definition: defn, points: word_pts)
  end

  last_word = entry[0]
end

# create new games, and simulate a game
alphabet = Array('a'..'z')
alphabet_capitalized = Array('A'..'Z')
guess_type = ["cheat", "lucky guess", "blind guess", "just wrong"]
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
      if guess_type.sample == "blind guess" || guess_type.sample == "just wrong"
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
