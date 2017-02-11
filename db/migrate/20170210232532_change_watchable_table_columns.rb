class ChangeWatchableTableColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :watchables, :moviedb_id, :tmdb_id
    rename_column :watchables, :moviedb_type, :tmdb_type
    add_column :watchables, :poster, :string

    remove_column :watchables, :imdb_id
  end
end
