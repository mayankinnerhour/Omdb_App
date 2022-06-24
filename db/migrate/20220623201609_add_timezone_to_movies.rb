class AddTimezoneToMovies < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :timezone, :string
  end
end
