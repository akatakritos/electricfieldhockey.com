class IncreaseJsonSize < ActiveRecord::Migration
  def up
    change_column :levels, :json, :string, :limit => 512
  end

  def down
    change_column :levels, :json, :string, :limit => 255
  end
end
