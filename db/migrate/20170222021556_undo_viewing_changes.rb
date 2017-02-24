class UndoViewingChanges < ActiveRecord::Migration[5.0]
  def change
    add_column :viewings, :viewed_id, :integer, null: false

    remove_column :viewings, :tmdb_id
    remove_column :viewings, :tmdb_type

    add_index :viewings, [:viewer_id, :viewed_id], :unique => true
  end
end
