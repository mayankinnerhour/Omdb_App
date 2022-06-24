class AddStartsAtToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :starts_at, :datetime
  end
end
