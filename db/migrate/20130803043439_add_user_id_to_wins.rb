class AddUserIdToWins < ActiveRecord::Migration
  def self.up
    add_column :level_wins, :user_id, :integer
  end

  def self.down
    remove_column :level_wins, :user_id
  end
end
