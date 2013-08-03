class CreateLevelWins < ActiveRecord::Migration
  def self.up
    create_table :level_wins do |t|
      t.integer :level_id
      t.string :level_json
      t.string :game_state
      t.integer :attempts
      t.integer :time

      t.timestamps
    end
  end

  def self.down
    drop_table :level_wins
  end
end
