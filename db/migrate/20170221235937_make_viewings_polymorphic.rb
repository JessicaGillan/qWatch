class MakeViewingsPolymorphic < ActiveRecord::Migration[5.0]
  def change
    remove_column :viewings, :viewed_id

    add_column :viewings, :tmdb_id, :integer, null: false
    add_column :viewings, :tmdb_type, :string, null: false

    add_index :viewings, [:viewer_id, :tmdb_type, :tmdb_id], :unique => true
  end
end
