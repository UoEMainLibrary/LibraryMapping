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

ActiveRecord::Schema.define(version: 20160531144833) do

  create_table "element_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",                  null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "svg_path"
    t.float    "width",      limit: 24
    t.float    "height",     limit: 24
  end

  create_table "elements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "element_type_id"
    t.float    "left",                limit: 24,                                       null: false
    t.float    "top",                 limit: 24,                                       null: false
    t.integer  "right",                                                  default: 0,   null: false
    t.integer  "bottom",                                                 default: 0,   null: false
    t.float    "angle",               limit: 24,                         default: 0.0, null: false
    t.string   "fill",                                                   default: "0"
    t.float    "opacity",             limit: 24,                         default: 1.0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "floor"
    t.float    "scaleX",              limit: 24
    t.float    "scaleY",              limit: 24
    t.decimal  "range_end",                      precision: 9, scale: 5
    t.decimal  "range_start",                    precision: 9, scale: 5
    t.string   "identifier"
    t.string   "range_end_opt"
    t.string   "range_end_letters"
    t.string   "range_end_digits"
    t.string   "range_start_opt"
    t.string   "range_start_letters"
    t.string   "range_start_digits"
    t.string   "library"
    t.index ["element_type_id"], name: "index_elements_on_element_type_id", using: :btree
  end

  create_table "feedback_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hub_lc_sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string  "letters", null: false
    t.integer "token",   null: false
    t.string  "name",    null: false
    t.index ["letters"], name: "index_hub_lc_sections_on_letters", unique: true, using: :btree
    t.index ["token"], name: "index_hub_lc_sections_on_token", unique: true, using: :btree
  end

  create_table "lc_sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string  "letters", null: false
    t.integer "token",   null: false
    t.string  "name",    null: false
    t.index ["letters"], name: "index_lc_sections_on_letters", unique: true, using: :btree
    t.index ["token"], name: "index_lc_sections_on_token", unique: true, using: :btree
  end

  create_table "murray_lc_sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string  "letters", null: false
    t.integer "token",   null: false
    t.string  "name",    null: false
    t.index ["letters"], name: "index_murray_lc_sections_on_letters", unique: true, using: :btree
    t.index ["token"], name: "index_murray_lc_sections_on_token", unique: true, using: :btree
  end

  create_table "usage_statistics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.boolean  "found",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
