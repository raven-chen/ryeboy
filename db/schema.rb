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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150920235535) do

  create_table "comments", :force => true do |t|
    t.integer  "author_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "content"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.datetime "read_at"
    t.integer  "user_id"
    t.integer  "replied_comment_id"
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "category"
  end

  create_table "exercises", :force => true do |t|
    t.date     "date"
    t.text     "content"
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "fan",                    :default => 0
    t.boolean  "ask_for_comment"
    t.boolean  "visible_to_mentor_only", :default => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "accessible_posts"
  end

  create_table "images", :force => true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "interests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exercise_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "interests", ["user_id", "exercise_id"], :name => "index_interests_on_user_id_and_exercise_id", :unique => true

  create_table "notifications", :force => true do |t|
    t.text     "content"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "category"
    t.string   "grade"
    t.string   "name"
  end

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "author_id"
    t.string   "category"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "rich_rich_files", :force => true do |t|
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "rich_file_file_name"
    t.string   "rich_file_content_type"
    t.integer  "rich_file_file_size"
    t.datetime "rich_file_updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "uri_cache"
    t.string   "simplified_type",        :default => "file"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.boolean  "common"
    t.date     "due_date"
    t.boolean  "required"
    t.boolean  "visible_to_admin_only"
    t.string   "grade"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "category"
  end

  create_table "user_activities", :force => true do |t|
    t.text     "note"
    t.boolean  "sign_in"
    t.boolean  "ask_for_leave"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_tasks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "roles_mask"
    t.date     "deleted_at"
    t.string   "name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "sno"
    t.integer  "group_id"
    t.string   "qq"
    t.string   "tel_number"
    t.string   "address"
    t.date     "birth_date"
    t.text     "note"
    t.string   "department"
    t.string   "grade"
    t.string   "real_name"
    t.string   "gender"
    t.text     "education_experience"
    t.text     "work_experience"
    t.text     "favorite"
    t.string   "available_time"
    t.boolean  "marriage"
    t.datetime "read_new_features_at"
    t.datetime "read_new_notices_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
