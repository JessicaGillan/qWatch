class CreatePosters < ActiveRecord::Migration[5.0]
  def change
    create_table :posters do |t|
      t.integer :watchable_id, null: false
      t.string  :thumbnail, default: nil
      t.string  :medium, default: nil
      t.string  :large, default: nil

      t.timestamps
    end

    add_index :posters, :watchable_id
  end
end
