# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130605154903) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "ancestry"
    t.integer  "tnid"
    t.integer  "ancestry_depth",   :default => 0
    t.string   "slug"
    t.string   "meta_title"
    t.text     "meta_description"
    t.string   "h1"
    t.text     "description"
    t.integer  "parent_tnid"
    t.integer  "grandparent_tnid"
    t.boolean  "visible",          :default => true
    t.boolean  "active",           :default => true
    t.string   "image_path"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"
  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "collections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "slug"
    t.integer  "category_id"
  end

  add_index "collections", ["slug"], :name => "index_collections_on_slug", :unique => true

  create_table "contact_us_messages", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "category_id"
    t.integer  "clicks"
    t.datetime "date"
    t.integer  "tnid"
    t.boolean  "is_womens"
    t.string   "img_static_url"
    t.string   "img_interactive_url"
    t.string   "name"
    t.string   "state_province"
    t.integer  "venue_id"
    t.integer  "venue_configuration"
    t.integer  "country_tnid"
    t.string   "slug"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "featured"
    t.text     "description"
    t.string   "main_category"
    t.string   "meta_title"
    t.text     "meta_description"
    t.string   "h1"
    t.boolean  "active",              :default => true
    t.string   "image_path"
    t.integer  "location_id"
    t.integer  "priority",            :default => 0
  end

  add_index "events", ["clicks"], :name => "index_events_on_clicks"
  add_index "events", ["date"], :name => "index_events_on_date"
  add_index "events", ["name"], :name => "index_events_on_name"
  add_index "events", ["slug"], :name => "index_events_on_slug", :unique => true

  create_table "events_performers", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "performer_id"
  end

  create_table "import_csvs", :force => true do |t|
    t.text     "output"
    t.string   "import_type"
    t.string   "csv_file_name"
    t.string   "csv_content_type"
    t.integer  "csv_file_size"
    t.datetime "csv_updated_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "listings", :force => true do |t|
    t.integer  "collection_id"
    t.integer  "collectible_id"
    t.string   "collectible_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "city"
    t.boolean  "listed_in_dropdown", :default => false
    t.string   "display_name"
  end

  add_index "locations", ["slug"], :name => "index_locations_on_slug", :unique => true

  create_table "performers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "tnid"
    t.integer  "category_id"
    t.string   "slug"
    t.text     "basic_info"
    t.text     "general_info"
    t.text     "extended_info"
    t.string   "meta_title"
    t.text     "meta_description"
    t.string   "h1"
    t.string   "image_path"
    t.boolean  "active",           :default => true
    t.integer  "priority",         :default => 0
  end

  add_index "performers", ["name"], :name => "index_performers_on_name"
  add_index "performers", ["slug"], :name => "index_performers_on_slug", :unique => true

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "rich_rich_files", :force => true do |t|
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        :default => "file"
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "static_pages", :force => true do |t|
    t.boolean  "active",                :default => true
    t.string   "permalink"
    t.string   "name"
    t.text     "content"
    t.string   "title"
    t.text     "meta_description"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "include_left_sidebar",  :default => true
    t.boolean  "include_right_sidebar", :default => true
  end

  create_table "testimonials", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "active"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.boolean  "admin"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "tnid"
    t.string   "country"
    t.string   "state_province"
    t.string   "zipcode"
    t.string   "street1"
    t.string   "street2"
    t.string   "slug"
    t.text     "basic_info"
    t.text     "general_info"
    t.text     "extended_info"
    t.string   "meta_title"
    t.text     "meta_description"
    t.string   "h1"
    t.integer  "location_id"
  end

  add_index "venues", ["name"], :name => "index_venues_on_name"
  add_index "venues", ["slug"], :name => "index_venues_on_slug", :unique => true

end
