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

ActiveRecord::Schema.define(version: 20160218074830) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",      null: false
    t.integer  "group",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_items", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "item_id",     null: false
    t.integer "category_id", null: false
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                                    null: false
    t.string   "code",                                    null: false
    t.integer  "quantity"
    t.text     "description",   limit: 65535,             null: false
    t.string   "image",                                   null: false
    t.integer  "status",                      default: 0, null: false
    t.boolean  "is_readable"
    t.boolean  "is_leaseable"
    t.boolean  "is_rateable"
    t.boolean  "is_reviewable"
    t.string   "type",                                    null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "publish_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "isbn",         null: false
    t.string   "author",       null: false
    t.date     "publish_date", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "item_id"
    t.index ["item_id"], name: "index_publish_details_on_item_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "role",       default: 0, null: false
    t.string   "name",                   null: false
    t.string   "email",                  null: false
    t.string   "uid",                    null: false
    t.string   "image"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "publish_details", "items"
end
