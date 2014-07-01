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

ActiveRecord::Schema.define(version: 20140607152032) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "absorbs", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "score"
    t.datetime "answer_revealed_at"
    t.datetime "scored_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "learning_boxes", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "level",       default: 3
    t.datetime "next_review"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "uid",                        null: false
    t.boolean  "guest",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

end
