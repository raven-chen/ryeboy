# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151128033241) do

  create_table "comments", force: :cascade do |t|
    t.integer  "author_id",          limit: 4
    t.integer  "commentable_id",     limit: 4
    t.string   "commentable_type",   limit: 255
    t.text     "content",            limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "read_at"
    t.integer  "user_id",            limit: 4
    t.integer  "replied_comment_id", limit: 4
  end

  add_index "comments", ["author_id"], name: "index_comments_on_author_id", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "content",    limit: 65535
    t.integer  "author_id",  limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "category",   limit: 255
  end

  create_table "exercises", force: :cascade do |t|
    t.date     "date"
    t.text     "content",                limit: 65535
    t.integer  "task_id",                limit: 4
    t.integer  "user_id",                limit: 4
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "fan",                    limit: 4,     default: 0
    t.boolean  "ask_for_comment"
    t.boolean  "visible_to_mentor_only",               default: false
    t.integer  "comments_count",         limit: 4,     default: 0
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "accessible_posts", limit: 255
  end

  create_table "homepage_items", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "category",   limit: 255
    t.string   "url",        limit: 255
    t.integer  "sequence",   limit: 4
    t.boolean  "view_more",              default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.integer  "attachment_file_size",    limit: 4
    t.datetime "attachment_updated_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "interests", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "exercise_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "interests", ["user_id", "exercise_id"], name: "index_interests_on_user_id_and_exercise_id", unique: true, using: :btree

  create_table "notifications", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.boolean  "active"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "category",   limit: 255
    t.string   "grade",      limit: 255
    t.string   "name",       limit: 255
  end

  create_table "posts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "content",    limit: 65535
    t.integer  "author_id",  limit: 4
    t.string   "category",   limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.text     "description",           limit: 65535
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "common"
    t.date     "due_date"
    t.boolean  "required"
    t.boolean  "visible_to_admin_only"
    t.string   "grade",                 limit: 255
    t.text     "template",              limit: 65535
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
    t.integer  "author_id",  limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "category",   limit: 255
  end

  create_table "user_activities", force: :cascade do |t|
    t.text     "note",          limit: 65535
    t.boolean  "sign_in"
    t.boolean  "ask_for_leave"
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "user_tasks", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "task_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "roles_mask",             limit: 4
    t.date     "deleted_at"
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "sno",                    limit: 255
    t.integer  "group_id",               limit: 4
    t.string   "qq",                     limit: 255
    t.string   "tel_number",             limit: 255
    t.string   "address",                limit: 255
    t.date     "birth_date"
    t.text     "note",                   limit: 65535
    t.string   "department",             limit: 255
    t.string   "grade",                  limit: 255
    t.string   "real_name",              limit: 255
    t.string   "gender",                 limit: 255
    t.text     "education_experience",   limit: 65535
    t.text     "work_experience",        limit: 65535
    t.text     "favorite",               limit: 65535
    t.string   "available_time",         limit: 255
    t.boolean  "marriage"
    t.datetime "read_new_features_at"
    t.datetime "read_new_notices_at"
    t.string   "sub_department",         limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
