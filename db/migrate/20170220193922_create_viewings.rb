class CreateViewings < ActiveRecord::Migration[5.0]
  def change
    create_table :viewings do |t|
      t.integer :viewed_id, :null => false
      t.integer :viewer_id, :null => false

      t.timestamps
    end

    add_index :viewings, [:viewer_id, :viewed_id], :unique => true
  end
end
