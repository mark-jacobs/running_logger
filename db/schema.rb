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

ActiveRecord::Schema.define(version: 20140625142747) do

  create_table "notes", force: true do |t|
    t.datetime "date"
    t.string   "note_item"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["date", "user_id"], name: "index_notes_on_date_and_user_id", unique: true

  create_table "races", force: true do |t|
    t.date     "race_date"
    t.string   "race_name"
    t.string   "distance"
    t.time     "finish_time"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "races", ["user_id"], name: "index_races_on_user_id"

  create_table "training_logs", force: true do |t|
    t.datetime "log_date"
    t.float    "log_miles"
    t.string   "log_workout"
    t.integer  "log_calories"
    t.boolean  "log_q"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "training_logs", ["log_date", "user_id"], name: "index_training_logs_on_log_date_and_user_id", unique: true

  create_table "training_plans", force: true do |t|
    t.datetime "plan_date"
    t.float    "plan_miles"
    t.string   "plan_workout"
    t.boolean  "plan_q"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "training_plans", ["plan_date", "user_id"], name: "index_training_plans_on_plan_date_and_user_id", unique: true

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
