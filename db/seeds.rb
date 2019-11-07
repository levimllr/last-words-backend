require 'csv'
require 'byebug'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



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
    "z" => 10,
    " " => 0,
    "-" => 0,
    "'" => 0
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

# byebug

csv.each do |entry|
  word_points = points(entry[0])
  Word.create(
    name: entry[0],
    major_class: entry[1],
    definition: entry[2],
    points: word_points
  )
end

puts "Seeded database!"
