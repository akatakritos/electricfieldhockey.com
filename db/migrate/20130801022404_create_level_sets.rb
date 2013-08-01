class CreateLevelSets < ActiveRecord::Migration
  def self.up
    create_table :level_sets do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :level_sets
  end
end
