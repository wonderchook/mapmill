class AddHitsIndex < ActiveRecord::Migration
  def self.up
    add_index :images, :hits
  end

  def self.down
    remove_index :images, :hits
  end
end
