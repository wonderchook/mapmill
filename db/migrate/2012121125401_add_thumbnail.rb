class AddThumbnail < ActiveRecord::Migration
  def self.up
    add_column :images, :thumbnail, :string, :default => ""
  end

  def self.down
    remove_column :images, :thumbnail
  end
end
