class DropPosterTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :posters
  end
end
