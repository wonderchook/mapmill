class AddUserInfoParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :login, :text, :default => ""
  end

  def self.down
    remove_column :participants, :login
  end
end
