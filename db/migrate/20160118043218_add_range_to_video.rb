class AddRangeToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :range, :string, :null => true
  end
end
