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

ActiveRecord::Schema.define(version: 20170210220300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posters", force: :cascade do |t|
    t.integer  "watchable_id", null: false
    t.string   "thumbnail"
    t.string   "medium"
    t.string   "large"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["watchable_id"], name: "index_posters_on_watchable_id", using: :btree
  end

  create_table "watchables", force: :cascade do |t|
    t.integer  "moviedb_id",   null: false
    t.string   "moviedb_type", null: false
    t.string   "title",        null: false
    t.string   "hulu"
    t.string   "amazon"
    t.string   "netflix"
    t.string   "xfinity"
    t.string   "amazon_buy"
    t.string   "google_play"
    t.string   "itunes"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "imdb_id",      null: false
    t.index ["imdb_id"], name: "index_watchables_on_imdb_id", using: :btree
    t.index ["moviedb_id", "moviedb_type"], name: "index_watchables_on_moviedb_id_and_moviedb_type", unique: true, using: :btree
    t.index ["moviedb_type"], name: "index_watchables_on_moviedb_type", using: :btree
  end

end
