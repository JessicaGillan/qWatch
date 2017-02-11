class ChangeToMovieDb < ActiveRecord::Migration[5.0]
  def change
    rename_column :watchables, :gb_id, :moviedb_id
    rename_column :watchables, :gb_type, :moviedb_type

    add_column :watchables, :imdb_id, :integer, null: false
    add_index :watchables, :imdb_id
  end
end
