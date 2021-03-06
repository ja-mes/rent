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

ActiveRecord::Schema.define(version: 20160724202250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "account_trans", force: :cascade do |t|
    t.decimal  "amount"
    t.string   "memo"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "property_id"
    t.integer  "account_transable_id"
    t.string   "account_transable_type"
    t.date     "date"
    t.index ["user_id"], name: "index_account_trans_on_user_id", using: :btree
  end

  create_table "account_types", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "inc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_account_types_on_user_id", using: :btree
  end

  create_table "accounts", force: :cascade do |t|
    t.string  "name"
    t.integer "user_id"
    t.boolean "required",        default: false
    t.integer "account_type_id"
    t.index ["name"], name: "index_accounts_on_name", using: :btree
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "checks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "num"
    t.date     "date"
    t.decimal  "amount"
    t.string   "memo"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "vendor_id"
    t.boolean  "cleared",           default: false, null: false
    t.integer  "reconciliation_id"
    t.index ["user_id"], name: "index_checks_on_user_id", using: :btree
  end

  create_table "credits", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.integer  "customer_id"
    t.date     "date"
    t.string   "memo"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id"], name: "index_credits_on_user_id", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.string  "last_name"
    t.string  "middle_name"
    t.string  "phone"
    t.integer "user_id"
    t.integer "property_id"
    t.string  "alt_phone"
    t.decimal "balance",       default: "0.0"
    t.string  "first_name"
    t.decimal "rent"
    t.string  "due_date"
    t.boolean "active",        default: true,     null: false
    t.date    "last_charged"
    t.string  "customer_type", default: "tenant"
    t.string  "company_name"
    t.index ["user_id"], name: "index_customers_on_user_id", using: :btree
  end

  create_table "deposits", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.date     "date"
    t.decimal  "discrepancies"
    t.boolean  "cleared",           default: false, null: false
    t.integer  "reconciliation_id"
    t.boolean  "internal",          default: false
    t.index ["user_id"], name: "index_deposits_on_user_id", using: :btree
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "user_id"
    t.integer "customer_id"
    t.decimal "amount"
    t.date    "date"
    t.string  "memo"
    t.date    "due_date"
    t.boolean "charged",     default: true
    t.index ["user_id"], name: "index_invoices_on_user_id", using: :btree
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "customer_id"
    t.date     "date"
    t.index ["user_id"], name: "index_notes_on_user_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "customer_id"
    t.decimal "amount"
    t.date    "date"
    t.string  "memo"
    t.integer "deposit_id"
    t.integer "account_id"
    t.string  "method"
    t.string  "num"
    t.index ["user_id"], name: "index_payments_on_user_id", using: :btree
  end

  create_table "properties", force: :cascade do |t|
    t.string  "address"
    t.string  "state"
    t.string  "city"
    t.string  "zip"
    t.decimal "rent"
    t.decimal "deposit"
    t.integer "user_id"
    t.boolean "rented",   default: false, null: false
    t.boolean "internal", default: false, null: false
    t.index ["user_id"], name: "index_properties_on_user_id", using: :btree
  end

  create_table "reconciliations", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.date     "date"
    t.decimal  "ending_balance"
    t.decimal  "cleared_balance"
    t.index ["user_id"], name: "index_reconciliations_on_user_id", using: :btree
  end

  create_table "recurring_trans", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.hstore   "account_trans",              array: true
    t.string   "due_date"
    t.string   "tran_type"
    t.integer  "charge_id"
    t.integer  "num"
    t.string   "memo"
    t.date     "last_charged"
    t.string   "description"
    t.date     "last_entry"
    t.index ["user_id"], name: "index_recurring_trans_on_user_id", using: :btree
  end

  create_table "registers", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name"
    t.decimal  "balance",         default: "0.0"
    t.decimal  "cleared_balance", default: "0.0"
    t.index ["user_id"], name: "index_registers_on_user_id", using: :btree
  end

  create_table "trans", force: :cascade do |t|
    t.integer "transactionable_id"
    t.string  "transactionable_type"
    t.integer "user_id"
    t.integer "customer_id"
    t.date    "date"
    t.index ["user_id"], name: "index_trans_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "vendors", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
  end

end
