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

ActiveRecord::Schema[7.1].define(version: 2024_01_29_085805) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bill_lines", force: :cascade do |t|
    t.bigint "bill_id", null: false
    t.string "product_no"
    t.string "product_name"
    t.string "product_group"
    t.integer "amount"
    t.decimal "price"
    t.string "unit"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_lines_on_bill_id"
  end

  create_table "bills", force: :cascade do |t|
    t.bigint "shift_id", null: false
    t.string "bill_no"
    t.string "table_no"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shift_id"], name: "index_bills_on_shift_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "key"
    t.date "expires_at"
    t.boolean "enabled", default: true
    t.boolean "sync_data", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_seen_at"
    t.index ["key"], name: "index_customers_on_key", unique: true
  end

  create_table "shifts", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "no"
    t.string "stt"
    t.decimal "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "shift_date"
    t.index ["customer_id"], name: "index_shifts_on_customer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "role", default: "user", null: false
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.bigint "customer_id"
    t.index ["customer_id"], name: "index_users_on_customer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "bill_lines", "bills"
  add_foreign_key "bills", "shifts"
  add_foreign_key "shifts", "customers"
  add_foreign_key "users", "customers"
end
