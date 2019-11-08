class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :username
      t.integer :total_score, default: 0

      t.timestamps
    end
  end
end
