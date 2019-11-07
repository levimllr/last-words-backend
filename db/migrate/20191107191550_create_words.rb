class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.string :name
      t.string :major_class
      t.string :definition
      t.integer :points

      t.timestamps
    end
  end
end
