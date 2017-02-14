class AddRequestedColumntoWatchables < ActiveRecord::Migration[5.0]
  def change
    add_column :watchables, :requested, :bool, default: false
  end
end
