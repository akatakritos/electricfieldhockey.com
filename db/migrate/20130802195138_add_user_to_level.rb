class AddUserToLevel < ActiveRecord::Migration
  def self.up
    add_column :levels, :creator_id, :integer
    add_index :levels, :creator_id
  end

  def self.down
    remove_column :levels, :creator_id
  end
end
