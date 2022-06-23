class RenameColunNameMovies < ActiveRecord::Migration[6.1]
  def change
    rename_column :movies, :type, :description
  end
end
