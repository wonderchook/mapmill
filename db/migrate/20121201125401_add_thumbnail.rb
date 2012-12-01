class AddThumbnail < ActiveRecord::Migration
  def self.up
    add_column :images, :thumbnail, :string, :default => ""
    add_column :images, :collection, :string, :default => ""
    add_column :images, :captured_at, :timestamp
  end

  def self.down
    remove_column :images, :thumbnail
    remove_column :images, :collection
    remove_column :images, :captured_at
  end
end
