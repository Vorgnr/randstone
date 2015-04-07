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

ActiveRecord::Schema.define(version: 20150406211531) do

  create_table "card_selections", force: :cascade do |t|
    t.string   "values",      limit: 255
    t.integer  "deck_id",     limit: 4
    t.boolean  "is_consumed", limit: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "set",         limit: 4
    t.integer  "quality",     limit: 4
    t.integer  "type_id",     limit: 4
    t.integer  "cost",        limit: 4
    t.integer  "health",      limit: 4
    t.integer  "attack",      limit: 4
    t.integer  "faction",     limit: 4
    t.integer  "hero_id",     limit: 4
    t.integer  "elite",       limit: 4
    t.integer  "collectible", limit: 4
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "popularity",  limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "cards_decks", id: false, force: :cascade do |t|
    t.integer "card_id", limit: 4, null: false
    t.integer "deck_id", limit: 4, null: false
  end

  create_table "collections", force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "card_id", limit: 4
  end

  add_index "collections", ["card_id"], name: "index_collections_on_card_id", using: :btree
  add_index "collections", ["user_id"], name: "index_collections_on_user_id", using: :btree

  create_table "decks", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "class_id",    limit: 4
    t.integer  "status",      limit: 4
    t.integer  "opponent_id", limit: 4
    t.integer  "hero_id",     limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id",     limit: 4
  end

  create_table "hero_selections", force: :cascade do |t|
    t.string   "values",     limit: 255
    t.integer  "deck_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "heroes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "class_name", limit: 255
    t.integer  "remote_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
