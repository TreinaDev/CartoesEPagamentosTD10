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

ActiveRecord::Schema[7.0].define(version: 2023_06_08_150804) do
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
    t.string "icon"
    t.integer "start_points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "emission", default: true
    t.index ["icon"], name: "index_card_types_on_icon", unique: true
    t.index ["name"], name: "index_card_types_on_name", unique: true
  end

  create_table "cards", force: :cascade do |t|
    t.string "number"
    t.string "cpf"
    t.integer "points"
    t.integer "status"
    t.integer "card_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_type_id"], name: "index_cards_on_card_type_id"
  end

  create_table "company_card_types", force: :cascade do |t|
    t.integer "status"
    t.string "cnpj"
    t.integer "card_type_id", null: false
    t.decimal "conversion_tax", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "payments", force: :cascade do |t|
    t.string "order_number"
    t.string "code"
    t.integer "total_value"
    t.integer "descount_amount"
    t.integer "final_value"
    t.integer "status"
    t.string "cpf"
    t.string "card_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cards", "card_types"
  add_foreign_key "company_card_types", "card_types"
end
