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

ActiveRecord::Schema[7.0].define(version: 2023_05_24_235016) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "team"
    t.string "down"
    t.string "distance"
    t.string "yardline_team"
    t.string "yardline_num"
    t.string "clock_status"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "explanation"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "downvotes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_downvotes_on_question_id"
    t.index ["user_id"], name: "index_downvotes_on_user_id"
  end

  create_table "question_references", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "reference_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_references_on_question_id"
    t.index ["reference_id"], name: "index_question_references_on_reference_id"
  end

  create_table "question_viewers", force: :cascade do |t|
    t.bigint "viewer_id"
    t.bigint "viewed_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["viewed_question_id"], name: "index_question_viewers_on_viewed_question_id"
    t.index ["viewer_id"], name: "index_question_viewers_on_viewer_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id", null: false
    t.index ["author_id"], name: "index_questions_on_author_id"
  end

  create_table "references", force: :cascade do |t|
    t.string "rule"
    t.string "section"
    t.string "article"
    t.string "subarticle"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_id"
    t.string "text"
    t.integer "length"
    t.string "label"
    t.index ["parent_id"], name: "index_references_on_parent_id"
  end

  create_table "upvotes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_upvotes_on_question_id"
    t.index ["user_id"], name: "index_upvotes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "downvotes", "questions"
  add_foreign_key "downvotes", "users"
  add_foreign_key "questions", "users", column: "author_id"
  add_foreign_key "upvotes", "questions"
  add_foreign_key "upvotes", "users"
end
