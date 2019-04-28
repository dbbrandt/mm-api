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

ActiveRecord::Schema.define(version: 20190427192253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contents", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "content_type"
    t.text "description"
    t.text "copy"
    t.float "score"
    t.text "descriptor"
    t.integer "interaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interaction_id"], name: "index_contents_on_interaction_id"
  end

  create_table "contents_back", id: false, force: :cascade do |t|
    t.integer "id"
    t.string "title"
    t.string "content_type"
    t.text "description"
    t.text "copy"
    t.float "score"
    t.text "descriptor"
    t.integer "interaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fae_changes", id: :serial, force: :cascade do |t|
    t.integer "changeable_id"
    t.string "changeable_type"
    t.integer "user_id"
    t.string "change_type"
    t.text "updated_attributes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["changeable_id"], name: "index_fae_changes_on_changeable_id"
    t.index ["changeable_type"], name: "index_fae_changes_on_changeable_type"
    t.index ["user_id"], name: "index_fae_changes_on_user_id"
  end

  create_table "fae_files", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "asset"
    t.string "fileable_type"
    t.integer "fileable_id"
    t.integer "file_size"
    t.integer "position", default: 0
    t.string "attached_as"
    t.boolean "on_stage", default: true
    t.boolean "on_prod", default: false
    t.boolean "required", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attached_as"], name: "index_fae_files_on_attached_as"
    t.index ["fileable_type", "fileable_id"], name: "index_fae_files_on_fileable_type_and_fileable_id"
  end

  create_table "fae_images", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "asset"
    t.string "imageable_type"
    t.integer "imageable_id"
    t.string "alt"
    t.string "caption"
    t.integer "position", default: 0
    t.string "attached_as"
    t.boolean "on_stage", default: true
    t.boolean "on_prod", default: false
    t.integer "file_size"
    t.boolean "required", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attached_as"], name: "index_fae_images_on_attached_as"
    t.index ["imageable_type", "imageable_id"], name: "index_fae_images_on_imageable_type_and_imageable_id"
  end

  create_table "fae_images_backup", id: false, force: :cascade do |t|
    t.integer "imageable_id"
    t.integer "id"
    t.string "asset"
  end

  create_table "fae_options", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "time_zone"
    t.string "colorway"
    t.string "stage_url"
    t.string "live_url"
    t.integer "singleton_guard"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["singleton_guard"], name: "index_fae_options_on_singleton_guard", unique: true
  end

  create_table "fae_roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fae_static_pages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "position", default: 0
    t.boolean "on_stage", default: true
    t.boolean "on_prod", default: false
    t.string "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["slug"], name: "index_fae_static_pages_on_slug"
  end

  create_table "fae_text_areas", id: :serial, force: :cascade do |t|
    t.string "label"
    t.text "content"
    t.integer "position", default: 0
    t.boolean "on_stage", default: true
    t.boolean "on_prod", default: false
    t.integer "contentable_id"
    t.string "contentable_type"
    t.string "attached_as"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attached_as"], name: "index_fae_text_areas_on_attached_as"
    t.index ["contentable_id"], name: "index_fae_text_areas_on_contentable_id"
    t.index ["contentable_type"], name: "index_fae_text_areas_on_contentable_type"
    t.index ["on_prod"], name: "index_fae_text_areas_on_on_prod"
    t.index ["on_stage"], name: "index_fae_text_areas_on_on_stage"
    t.index ["position"], name: "index_fae_text_areas_on_position"
  end

  create_table "fae_text_fields", id: :serial, force: :cascade do |t|
    t.string "contentable_type"
    t.integer "contentable_id"
    t.string "attached_as"
    t.string "label"
    t.string "content"
    t.integer "position", default: 0
    t.boolean "on_stage", default: true
    t.boolean "on_prod", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attached_as"], name: "index_fae_text_fields_on_attached_as"
    t.index ["contentable_type", "contentable_id"], name: "index_fae_text_fields_on_contentable_type_and_contentable_id"
    t.index ["on_prod"], name: "index_fae_text_fields_on_on_prod"
    t.index ["on_stage"], name: "index_fae_text_fields_on_on_stage"
    t.index ["position"], name: "index_fae_text_fields_on_position"
  end

  create_table "fae_users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "first_name"
    t.string "last_name"
    t.integer "role_id"
    t.boolean "active"
    t.string "language"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["confirmation_token"], name: "index_fae_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_fae_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_fae_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_fae_users_on_role_id"
    t.index ["unlock_token"], name: "index_fae_users_on_unlock_token", unique: true
  end

  create_table "goals", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.text "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "import_files", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "json_data"
    t.integer "goal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_import_files_on_goal_id"
  end

  create_table "import_rows", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "json_data"
    t.integer "import_file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_file_id"], name: "index_import_rows_on_import_file_id"
  end

  create_table "interactions", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "answer_type"
    t.integer "goal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "import_row_id"
    t.index ["goal_id"], name: "index_interactions_on_goal_id"
    t.index ["import_row_id"], name: "index_interactions_on_import_row_id"
  end

  create_table "interactions_load", id: false, force: :cascade do |t|
    t.bigint "id"
    t.string "name"
  end

  create_table "round_responses", force: :cascade do |t|
    t.bigint "round_id"
    t.bigint "interaction_id"
    t.text "answer"
    t.float "score"
    t.boolean "is_correct"
    t.boolean "review_is_correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interaction_id"], name: "index_round_responses_on_interaction_id"
    t.index ["round_id"], name: "index_round_responses_on_round_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.bigint "goal_id"
    t.bigint "fae_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fae_user_id"], name: "index_rounds_on_fae_user_id"
    t.index ["goal_id"], name: "index_rounds_on_goal_id"
  end

  add_foreign_key "contents", "interactions"
  add_foreign_key "import_files", "goals"
  add_foreign_key "import_rows", "import_files"
  add_foreign_key "interactions", "goals"
  add_foreign_key "interactions", "import_rows"
  add_foreign_key "round_responses", "interactions"
  add_foreign_key "round_responses", "rounds"
  add_foreign_key "rounds", "fae_users"
  add_foreign_key "rounds", "goals"
end
