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

ActiveRecord::Schema.define(version: 20180321180753) do

  create_table "crono_jobs", force: :cascade do |t|
    t.string   "job_id",                               null: false
    t.text     "log",               limit: 1073741823
    t.datetime "last_performed_at"
    t.boolean  "healthy"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "crono_jobs", ["job_id"], name: "index_crono_jobs_on_job_id", unique: true

  create_table "devices", force: :cascade do |t|
    t.string   "name"
    t.string   "hostname"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "monitored_service_logs", force: :cascade do |t|
    t.integer  "monitored_service_id"
    t.float    "delay"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.float    "delivery_ratio"
  end

  add_index "monitored_service_logs", ["monitored_service_id"], name: "index_monitored_service_logs_on_monitored_service_id"

  create_table "monitored_services", force: :cascade do |t|
    t.integer  "service_type"
    t.integer  "port"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
    t.integer  "device_id"
    t.integer  "status"
  end

  add_index "monitored_services", ["device_id"], name: "index_monitored_services_on_device_id"

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true

  create_table "telegram_users", force: :cascade do |t|
    t.integer  "telegram_id"
    t.string   "first_name"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "telegram_users", ["telegram_id"], name: "index_telegram_users_on_telegram_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "login"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
