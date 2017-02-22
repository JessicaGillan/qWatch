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

ActiveRecord::Schema.define(version: 20170222175947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "btree_gin"

  create_table "friendings", force: :cascade do |t|
    t.integer  "friend_id",   null: false
    t.integer  "friender_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["friend_id", "friender_id"], name: "index_friendings_on_friend_id_and_friender_id", unique: true, using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.string  "uid"
    t.string  "provider"
    t.integer "user_id"
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "tmdb_configs", force: :cascade do |t|
    t.string   "url",                     null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "secure_url"
    t.string   "sizes",      default: [],              array: true
  end

  create_table "user_authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "token_expires_at"
    t.text     "params"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["provider"], name: "index_user_authentications_on_provider", using: :btree
    t.index ["user_id"], name: "index_user_authentications_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "viewings", force: :cascade do |t|
    t.integer  "viewer_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "viewed_id",  null: false
    t.index ["viewer_id", "viewed_id"], name: "index_viewings_on_viewer_id_and_viewed_id", unique: true, using: :btree
  end

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

  add_foreign_key "identities", "users"
end
