class CreateGameWords < ActiveRecord::Migration[6.0]
  def change
    create_table :game_words do |t|
      t.integer :game_id
      t.integer :word_id
      t.string :misses
      t.integer :score
      t.boolean :win

      t.timestamps
    end
  end
end
