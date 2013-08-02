class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :limit => 50
      t.string :username, :null => false, :limit => 25
      t.string :name, :limit => 50
      t.boolean :admin, :null => false, :default => false
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end

    add_index :users, [:username], :unique => true
  end

  def self.down
    drop_table :users
  end
end
