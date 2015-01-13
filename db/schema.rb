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

ActiveRecord::Schema.define(version: 20150113173000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "classifications", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "designation",    null: false
    t.string   "classification"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "classifications", ["designation", "classification"], name: "index_classifications_on_designation_and_classification", unique: true, using: :btree

  create_table "locations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",       null: false
    t.uuid     "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "locations", ["parent_id", "name"], name: "index_locations_on_parent_id_and_name", unique: true, using: :btree

  create_table "producers", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "producers", ["name"], name: "index_producers_on_name", unique: true, using: :btree

  create_table "wines", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",                          null: false
    t.integer  "colour",            default: 0, null: false
    t.integer  "wine_type",         default: 0, null: false
    t.uuid     "producer_id"
    t.uuid     "location_id",                   null: false
    t.uuid     "classification_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_foreign_key "locations", "locations", column: "parent_id", on_update: :restrict, on_delete: :restrict
  add_foreign_key "wines", "classifications", on_update: :restrict, on_delete: :restrict
  add_foreign_key "wines", "locations", on_update: :restrict, on_delete: :restrict
  add_foreign_key "wines", "producers", on_update: :restrict, on_delete: :restrict
end
