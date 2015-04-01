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

ActiveRecord::Schema.define(version: 20150401121239) do

  create_table "card_selections", force: :cascade do |t|
    t.string   "values",     limit: 255
    t.integer  "deck_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
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

  create_table "cards_users", id: false, force: :cascade do |t|
    t.integer "card_id", limit: 4, null: false
    t.integer "user_id", limit: 4, null: false
  end

  create_table "decks", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "class_id",    limit: 4
    t.integer  "status",      limit: 4
    t.integer  "opponent_id", limit: 4
    t.integer  "hero_id",     limit: 4
    t.integer  "card_a_id",   limit: 4
    t.integer  "card_b_id",   limit: 4
    t.integer  "card_c_id",   limit: 4
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
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
