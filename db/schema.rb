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

ActiveRecord::Schema.define(version: 20160603092911) do

  create_table "item_bundles", force: :cascade do |t|
    t.integer  "item_id",              limit: 4
    t.integer  "item_source_id",       limit: 4
    t.float    "item_source_quantity", limit: 24
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer  "item_id",           limit: 4
    t.string   "item_number",       limit: 255
    t.string   "item_name",         limit: 255
    t.string   "item_manufacturer", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "order_id",       limit: 4
    t.integer  "item_id",        limit: 4
    t.float    "item_quantity",  limit: 24
    t.float    "order_amount",   limit: 24
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "order_referrer", limit: 255
  end

end
