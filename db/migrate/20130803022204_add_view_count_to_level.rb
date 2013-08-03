class AddViewCountToLevel < ActiveRecord::Migration
  def self.up
    add_column :levels, :view_count, :integer, :default => 0
  end

  def self.down
    remove_column :levels, :view_count
  end
end
