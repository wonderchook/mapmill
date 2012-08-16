class Addpolygon < ActiveRecord::Migration
  def self.up
    add_column :images, :box, :string, :default => ""
  end

  def self.down
    remove_column :images, :box
  end
end
