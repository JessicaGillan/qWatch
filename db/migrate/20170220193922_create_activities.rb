class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :user_id, :null => false
      t.integer :tmdb_id, :null => false

      t.timestamps
    end

    add_index :activities, [:user_id, :tmdb_id], :unique => true
  end
end
