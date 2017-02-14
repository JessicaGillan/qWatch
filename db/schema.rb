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

ActiveRecord::Schema.define(version: 20170213221917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "btree_gin"

  create_table "watchables", force: :cascade do |t|
    t.integer  "tmdb_id",                     null: false
    t.string   "tmdb_type",                   null: false
    t.string   "title",                       null: false
    t.string   "hulu"
    t.string   "amazon"
    t.string   "netflix"
    t.string   "xfinity"
    t.string   "amazon_buy"
    t.string   "google_play"
    t.string   "itunes"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "poster"
    t.boolean  "requested",   default: false
    t.index "title gin_trgm_ops", name: "watchables_search_idx", using: :gin
    t.index ["tmdb_id", "tmdb_type"], name: "index_watchables_on_tmdb_id_and_tmdb_type", unique: true, using: :btree
    t.index ["tmdb_type"], name: "index_watchables_on_tmdb_type", using: :btree
  end

end
