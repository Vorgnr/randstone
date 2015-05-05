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

ActiveRecord::Schema.define(version: 20150505210357) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_selections", force: :cascade do |t|
    t.string   "values"
    t.integer  "deck_id"
    t.boolean  "is_consumed"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "cards", force: :cascade do |t|
    t.integer  "set"
    t.integer  "quality"
    t.integer  "type_id"
    t.integer  "cost"
    t.integer  "health"
    t.integer  "attack"
    t.integer  "faction"
    t.integer  "hero_id"
    t.integer  "elite"
    t.integer  "collectible"
    t.string   "name"
    t.string   "description"
    t.integer  "popularity"
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "cards_decks", id: false, force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "deck_id", null: false
  end

  create_table "collections", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
  end

  add_index "collections", ["card_id"], name: "index_collections_on_card_id", using: :btree
  add_index "collections", ["user_id"], name: "index_collections_on_user_id", using: :btree

  create_table "decks", force: :cascade do |t|
    t.string   "name"
    t.integer  "class_id"
    t.integer  "status"
    t.integer  "hero_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "hero_selections", force: :cascade do |t|
    t.string   "values"
    t.integer  "deck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "heroes", force: :cascade do |t|
    t.string   "name"
    t.string   "class_name"
    t.integer  "remote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prints", force: :cascade do |t|
    t.integer "user_id"
    t.integer "card_id"
  end

  add_index "prints", ["card_id"], name: "index_prints_on_card_id", using: :btree
  add_index "prints", ["user_id"], name: "index_prints_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
