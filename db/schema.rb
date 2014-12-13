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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141213214433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_links", force: true do |t|
    t.string   "api_key"
    t.integer  "place_id"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string  "name"
    t.integer "capacity"
    t.boolean "hidden"
    t.integer "parent_category_id"
    t.string  "slug"
  end

  create_table "categories_places", id: false, force: true do |t|
    t.integer "category_id", null: false
    t.integer "place_id",    null: false
  end

  add_index "categories_places", ["category_id", "place_id"], name: "index_categories_places_on_category_id_and_place_id", using: :btree
  add_index "categories_places", ["place_id", "category_id"], name: "index_categories_places_on_place_id_and_category_id", using: :btree

  create_table "place_statistics", force: true do |t|
    t.integer  "place_id"
    t.integer  "source_id"
    t.integer  "measurement",   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "raw_data"
    t.string   "raw_data_type"
  end

  create_table "places", force: true do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.text     "address"
    t.integer  "capacity"
    t.string   "slug"
  end

  create_table "sources", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
