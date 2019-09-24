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

ActiveRecord::Schema.define(version: 20161103070726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "identifier"
    t.string   "phone_number"
    t.string   "fantasy_name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "authentication_token"
    t.index ["email"], name: "index_businesses_on_email", using: :btree
    t.index ["fantasy_name"], name: "index_businesses_on_fantasy_name", using: :btree
    t.index ["identifier"], name: "index_businesses_on_identifier", using: :btree
    t.index ["name"], name: "index_businesses_on_name", using: :btree
    t.index ["phone_number"], name: "index_businesses_on_phone_number", using: :btree
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "identifier"
    t.boolean  "active",                                  default: true
    t.integer  "times_redeemed",                          default: 0
    t.datetime "redeem_by"
    t.string   "duration"
    t.string   "currency",                                default: "KES"
    t.decimal  "percent_off",    precision: 64, scale: 6
    t.decimal  "amount_off",     precision: 64, scale: 6
    t.jsonb    "metadata",                                default: {}
    t.integer  "user_id"
    t.integer  "business_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.index ["business_id"], name: "index_coupons_on_business_id", using: :btree
    t.index ["user_id"], name: "index_coupons_on_user_id", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.string   "identifier"
    t.string   "currency"
    t.text     "description"
    t.string   "name"
    t.string   "email"
    t.string   "mobile_number"
    t.integer  "business_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["business_id"], name: "index_customers_on_business_id", using: :btree
    t.index ["email"], name: "index_customers_on_email", using: :btree
    t.index ["mobile_number"], name: "index_customers_on_mobile_number", using: :btree
    t.index ["name"], name: "index_customers_on_name", using: :btree
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "due_date"
    t.text     "description"
    t.string   "status",                                   default: "verynew"
    t.string   "currency",                                 default: "KES"
    t.decimal  "amount_due",      precision: 32, scale: 4
    t.string   "identifier"
    t.string   "receipt_number"
    t.integer  "customer_id"
    t.integer  "business_id"
    t.integer  "subscription_id"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.decimal  "balance",         precision: 64, scale: 6, default: "0.0"
    t.decimal  "paid",            precision: 64, scale: 6, default: "0.0"
    t.decimal  "discount",        precision: 64, scale: 6
    t.decimal  "relief",          precision: 64, scale: 6
    t.index ["business_id"], name: "index_invoices_on_business_id", using: :btree
    t.index ["customer_id"], name: "index_invoices_on_customer_id", using: :btree
    t.index ["identifier"], name: "index_invoices_on_identifier", using: :btree
    t.index ["receipt_number"], name: "index_invoices_on_receipt_number", using: :btree
    t.index ["subscription_id"], name: "index_invoices_on_subscription_id", using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "business_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["business_id"], name: "index_memberships_on_business_id", using: :btree
    t.index ["user_id"], name: "index_memberships_on_user_id", using: :btree
  end

  create_table "plans", force: :cascade do |t|
    t.string   "identifier"
    t.string   "name"
    t.decimal  "amount",         precision: 10, scale: 3
    t.string   "currency",                                default: "KES"
    t.string   "interval"
    t.integer  "interval_count",                          default: 1
    t.boolean  "livemode"
    t.text     "description"
    t.datetime "start"
    t.integer  "business_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.index ["business_id"], name: "index_plans_on_business_id", using: :btree
    t.index ["name"], name: "index_plans_on_name", using: :btree
  end

  create_table "schedules", force: :cascade do |t|
    t.datetime "scheduled_at"
    t.string   "identifier"
    t.string   "recurrence_interval"
    t.integer  "rety_count",          default: 0
    t.string   "status",              default: "inactive"
    t.jsonb    "metadata"
    t.integer  "subscription_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["identifier"], name: "index_schedules_on_identifier", using: :btree
    t.index ["subscription_id"], name: "index_schedules_on_subscription_id", using: :btree
  end

  create_table "subscribe_transactions", force: :cascade do |t|
    t.string   "origin"
    t.string   "msisdn"
    t.string   "sender"
    t.decimal  "actual_amount",   precision: 64, scale: 5
    t.decimal  "trans_amount",    precision: 64, scale: 5
    t.string   "bill_ref_number"
    t.string   "trans_id"
    t.datetime "trans_time"
    t.integer  "business_id"
    t.integer  "customer_id"
    t.integer  "invoice_id"
    t.integer  "subscription_id"
    t.jsonb    "raw_transaction"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "identifier"
    t.index ["bill_ref_number"], name: "index_subscribe_transactions_on_bill_ref_number", using: :btree
    t.index ["business_id"], name: "index_subscribe_transactions_on_business_id", using: :btree
    t.index ["customer_id"], name: "index_subscribe_transactions_on_customer_id", using: :btree
    t.index ["invoice_id"], name: "index_subscribe_transactions_on_invoice_id", using: :btree
    t.index ["msisdn"], name: "index_subscribe_transactions_on_msisdn", using: :btree
    t.index ["sender"], name: "index_subscribe_transactions_on_sender", using: :btree
    t.index ["subscription_id"], name: "index_subscribe_transactions_on_subscription_id", using: :btree
    t.index ["trans_id"], name: "index_subscribe_transactions_on_trans_id", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string   "identifier"
    t.integer  "quantity",    default: 1
    t.datetime "start"
    t.integer  "business_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "plan_id"
    t.integer  "customer_id"
    t.string   "status",      default: "inactive"
    t.integer  "coupon_id"
    t.index ["business_id"], name: "index_subscriptions_on_business_id", using: :btree
    t.index ["coupon_id"], name: "index_subscriptions_on_coupon_id", using: :btree
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id", using: :btree
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
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
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "mobile_number"
    t.string   "authentication_token"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  add_foreign_key "coupons", "businesses"
  add_foreign_key "coupons", "users"
  add_foreign_key "customers", "businesses"
  add_foreign_key "invoices", "businesses"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "subscriptions"
  add_foreign_key "memberships", "businesses"
  add_foreign_key "memberships", "users"
  add_foreign_key "schedules", "subscriptions"
  add_foreign_key "subscribe_transactions", "businesses"
  add_foreign_key "subscribe_transactions", "customers"
  add_foreign_key "subscribe_transactions", "invoices"
  add_foreign_key "subscribe_transactions", "subscriptions"
  add_foreign_key "subscriptions", "businesses"
  add_foreign_key "subscriptions", "coupons"
  add_foreign_key "subscriptions", "customers"
  add_foreign_key "subscriptions", "plans"
end
