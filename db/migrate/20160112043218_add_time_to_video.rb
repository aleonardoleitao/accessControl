class AddTimeToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :time, :datetime, :null => true
  end
end
