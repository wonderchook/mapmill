class AddLatLongMgrs < ActiveRecord::Migration
  def self.up
    add_column :images, :lat, :decimal, :default => 0
    add_column :images, :lon, :decimal, :default => 0
    add_column :images, :mgrs, :string, :default => ""
  end

  def self.down
    remove_column :images, :lat
    remove_column :images, :lon
    remove_column :images, :mgrs
  end
end
