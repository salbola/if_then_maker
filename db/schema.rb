# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_01_14_062507) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "if_then_rules", force: :cascade do |t|
    t.text "if_condition"
    t.text "then_action"
    t.integer "status", default: 0, null: false
    t.bigint "user_id", null: false
    t.bigint "memo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["memo_id"], name: "index_if_then_rules_on_memo_id"
    t.index ["user_id"], name: "index_if_then_rules_on_user_id"
  end

  create_table "memos", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_memos_on_user_id"
  end

  create_table "reflections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "if_then_rule_id", null: false
    t.date "reflected_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["if_then_rule_id"], name: "index_reflections_on_if_then_rule_id"
    t.index ["user_id", "if_then_rule_id", "reflected_on"], name: "index_reflections_on_user_rule_and_date", unique: true
    t.index ["user_id"], name: "index_reflections_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "if_then_rules", "memos"
  add_foreign_key "if_then_rules", "users"
  add_foreign_key "memos", "users"
  add_foreign_key "reflections", "if_then_rules"
  add_foreign_key "reflections", "users"
end
