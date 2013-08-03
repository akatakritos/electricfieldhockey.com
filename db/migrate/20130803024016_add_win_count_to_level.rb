class AddWinCountToLevel < ActiveRecord::Migration
  def self.up
    add_column :levels, :level_wins_count, :integer, :default => 0

    Level.reset_column_information
    Level.find(:all).each do |l|
      Level.update_counters l.id, :level_wins_count => l.level_wins.length
    end
  end

  def self.down
    remove_column :levels, :level_wins_count
  end
end
