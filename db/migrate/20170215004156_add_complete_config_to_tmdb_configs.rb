class AddCompleteConfigToTmdbConfigs < ActiveRecord::Migration[5.0]
  def change
    add_column :tmdb_configs, :secure_url, :string
    add_column :tmdb_configs, :sizes, :string, array: true, default: []
  end
end
