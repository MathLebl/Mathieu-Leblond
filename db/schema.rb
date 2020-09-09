# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_09_192228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "educations", force: :cascade do |t|
    t.string "institution"
    t.string "title"
    t.date "start"
    t.date "end"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_educations_on_user_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.string "entreprise"
    t.date "start"
    t.date "end"
    t.string "role"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_experiences_on_user_id"
  end

  create_table "interests", force: :cascade do |t|
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_interests_on_user_id"
  end

  create_table "realisations", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "category"
    t.string "link"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_realisations_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.integer "range"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "address"
    t.string "last_name"
    t.string "mail"
    t.string "phone"
    t.text "description"
    t.date "birthdate"
    t.boolean "admin"
    t.string "lkd"
    t.string "insta"
    t.string "ghub"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "xp_descriptions", force: :cascade do |t|
    t.text "text"
    t.bigint "experience_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["experience_id"], name: "index_xp_descriptions_on_experience_id"
  end

  create_table "xp_items", force: :cascade do |t|
    t.string "item"
    t.bigint "xp_description_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "arrow"
    t.index ["xp_description_id"], name: "index_xp_items_on_xp_description_id"
  end

  add_foreign_key "educations", "users"
  add_foreign_key "experiences", "users"
  add_foreign_key "interests", "users"
  add_foreign_key "realisations", "users"
  add_foreign_key "skills", "users"
  add_foreign_key "xp_descriptions", "experiences"
  add_foreign_key "xp_items", "xp_descriptions"
end
