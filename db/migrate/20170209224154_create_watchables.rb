class CreateWatchables < ActiveRecord::Migration[5.0]
  def change
    create_table :watchables do |t|
      t.integer :gb_id, null: false
      t.string :gb_type, null: false
      t.string :title, null: false
      t.string :hulu, default: nil
      t.string :amazon, default: nil
      t.string :netflix, default: nil
      t.string :xfinity, default: nil
      t.string :amazon_buy, default: nil
      t.string :google_play, default: nil
      t.string :itunes, default: nil

      t.timestamps
    end

    add_index :watchables, [:gb_id, :gb_type], unique: true
    add_index :watchables, :gb_type
  end
end
