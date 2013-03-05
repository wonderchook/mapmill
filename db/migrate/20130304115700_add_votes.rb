class AddVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :participant_id
      t.integer :image_id
      t.integer :rating
      t.string  :email
      t.string  :ip_address
      t.timestamps
    end
    add_index :votes, :participant_id
    add_index :votes, :image_id
  end

  def self.down
    drop_table :votes
  end
end
