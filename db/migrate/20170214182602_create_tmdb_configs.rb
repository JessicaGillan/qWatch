class CreateTMDBConfigs < ActiveRecord::Migration[5.0]
  def change
    create_table :tmdb_configs do |t|
      t.string :url, null: false
      t.timestamps
    end
  end
end
