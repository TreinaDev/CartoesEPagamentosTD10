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

ActiveRecord::Schema[7.0].define(version: 2023_06_21_215203) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cpf"
    t.index ["cpf"], name: "index_admins_on_cpf", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "card_types", force: :cascade do |t|
    t.string "name"
    t.integer "start_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "emission", default: true
    t.index ["name"], name: "index_card_types_on_name", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.string "number"
    t.string "cpf"
    t.integer "points"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_card_type_id", null: false
    t.index ["company_card_type_id"], name: "index_cards_on_company_card_type_id"
  end

  create_table "cashback_rules", force: :cascade do |t|
    t.integer "minimum_amount_points"
    t.decimal "cashback_percentage", precision: 4, scale: 2
    t.integer "days_to_use"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cashback_percentage", "minimum_amount_points", "days_to_use"], name: "index_cashback_rules_on_minimum_amount_points_and_days_to_use", unique: true
  end

  create_table "company_card_types", force: :cascade do |t|
    t.integer "status", default: 1
    t.string "cnpj"
    t.integer "card_type_id", null: false
    t.decimal "conversion_tax", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_type_id", "cnpj"], name: "index_company_card_types_on_card_type_id_and_cnpj", unique: true
    t.index ["card_type_id"], name: "index_company_card_types_on_card_type_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "deposits", force: :cascade do |t|
    t.integer "card_id", null: false
    t.integer "amount"
    t.string "description"
    t.string "deposit_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_deposits_on_card_id"
  end

  create_table "error_messages", force: :cascade do |t|
    t.string "code"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_error_messages_on_code", unique: true
  end

  create_table "errors_associations", force: :cascade do |t|
    t.integer "payment_id", null: false
    t.integer "error_message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["error_message_id"], name: "index_errors_associations_on_error_message_id"
    t.index ["payment_id"], name: "index_errors_associations_on_payment_id"
  end

  create_table "extracts", force: :cascade do |t|
    t.datetime "date"
    t.string "operation_type"
    t.integer "value"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "card_number"
  end

  create_table "payments", force: :cascade do |t|
    t.string "order_number"
    t.string "code"
    t.integer "total_value"
    t.integer "descount_amount"
    t.integer "final_value"
    t.string "cpf"
    t.string "card_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "payment_date"
    t.integer "status", default: 0
    t.index ["code"], name: "index_payments_on_code", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cards", "company_card_types"
  add_foreign_key "company_card_types", "card_types"
  add_foreign_key "deposits", "cards"
  add_foreign_key "errors_associations", "error_messages"
  add_foreign_key "errors_associations", "payments"
end
