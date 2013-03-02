class UniqueIndex < ActiveRecord::Migration
  def self.up
    add_index :images, :path, :unique => true
  end

  def self.down
    remove_index :images, :path
  end
end
