class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :year
      t.string :genre
      t.string :rated
      t.date :release
      t.time :runtime
      t.string :type

      t.timestamps
    end
  end
end
