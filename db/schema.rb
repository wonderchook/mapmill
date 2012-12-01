# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121201125401) do

  create_table "all_votes", :id => false, :force => true do |t|
    t.string  "date",  :limit => nil
    t.string  "time",  :limit => nil
    t.string  "site",  :limit => nil
    t.string  "email", :limit => nil
    t.string  "ip",    :limit => nil
    t.integer "image"
    t.decimal "score"
  end

  add_index "all_votes", ["site"], :name => "all_votes_site"

  create_table "giscorps_pilot_sample", :id => false, :force => true do |t|
    t.string  "file",          :limit => nil
    t.integer "sample_set"
    t.integer "image"
    t.integer "site_id"
    t.string  "mgrs",          :limit => nil
    t.integer "mapmill_image"
  end

  create_table "giscorps_pilot_votes", :id => false, :force => true do |t|
    t.string  "date",         :limit => nil
    t.string  "time",         :limit => nil
    t.string  "site",         :limit => nil
    t.string  "email",        :limit => nil
    t.string  "ip",           :limit => nil
    t.integer "image"
    t.decimal "score"
    t.string  "mgrs",         :limit => nil
    t.string  "damage",       :limit => nil
    t.string  "inundation",   :limit => nil
    t.string  "damage_type",  :limit => nil
    t.string  "damage_combo", :limit => nil
    t.decimal "damage_value"
  end

  create_table "image_agreement", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "date_",     :limit => nil
    t.string  "time_",     :limit => nil
    t.integer "votes"
    t.float   "damage"
    t.float   "agreement"
  end

  create_table "image_check_sample", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "path", :limit => nil
  end

  create_table "image_diff", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "mgrs"
    t.decimal "mm_damage"
    t.float   "ic_damage"
    t.float   "delta"
    t.integer "votes"
  end

  create_table "imagecat", :id => false, :force => true do |t|
    t.string "usng",   :limit => nil
    t.float  "damage"
  end

  create_table "imagecat2", :id => false, :force => true do |t|
    t.string "usng",   :limit => nil
    t.float  "damage"
  end

  add_index "imagecat2", ["usng"], :name => "imagecat2_usng", :unique => true

  create_table "imagecat_damage", :id => false, :force => true do |t|
    t.string "usng",         :limit => nil
    t.string "damage",       :limit => nil
    t.string "inundation",   :limit => nil
    t.string "damage_type",  :limit => nil
    t.string "damage_combo", :limit => nil
  end

  add_index "imagecat_damage", ["usng"], :name => "imagecat_damage_usng"

  create_table "images", :force => true do |t|
    t.integer  "hits",        :default => 0,   :null => false
    t.string   "filename",    :default => "",  :null => false
    t.string   "path",        :default => "",  :null => false
    t.integer  "points",      :default => 0,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.decimal  "lat",         :default => 0.0
    t.decimal  "lon",         :default => 0.0
    t.string   "mgrs",        :default => ""
    t.string   "box",         :default => ""
    t.string   "thumbnail",   :default => ""
    t.string   "collection",  :default => ""
    t.datetime "captured_at"
  end

  create_table "participants", :force => true do |t|
    t.integer  "site_id"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "login",      :default => ""
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active",                                       :default => true
    t.decimal  "lat",          :precision => 20, :scale => 10, :default => 0.0
    t.decimal  "lon",          :precision => 20, :scale => 10, :default => 0.0
    t.decimal  "end_lat",      :precision => 20, :scale => 10, :default => 0.0
    t.decimal  "end_lon",      :precision => 20, :scale => 10, :default => 0.0
    t.datetime "capture_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "map_export",                                   :default => ""
  end

end
