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

ActiveRecord::Schema.define(:version => 20130215223102) do

  create_table "assignment_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "assignments", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "course_id"
    t.integer  "assignment_type_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "assignments", ["assignment_type_id"], :name => "index_assignments_on_assignment_type_id"
  add_index "assignments", ["course_id"], :name => "index_assignments_on_course_id"

  create_table "attachments", :force => true do |t|
    t.string   "media_file_name"
    t.string   "media_content_type"
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
    t.integer  "transcoding_status", :default => 0
    t.string   "transcoding_error"
    t.integer  "fileable_id"
    t.string   "fileable_type"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "attachments", ["fileable_id", "fileable_type"], :name => "index_attachments_on_fileable_id_and_fileable_type"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "department"
    t.string   "number"
    t.string   "section"
    t.text     "description"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "courses", ["organization_id"], :name => "index_courses_on_organization_id"

  create_table "courses_helpers", :force => true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "courses_helpers", ["course_id"], :name => "index_courses_helpers_on_course_id"
  add_index "courses_helpers", ["user_id"], :name => "index_courses_helpers_on_user_id"

  create_table "courses_instructors", :force => true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "courses_instructors", ["course_id"], :name => "index_courses_instructors_on_course_id"
  add_index "courses_instructors", ["user_id"], :name => "index_courses_instructors_on_user_id"

  create_table "courses_students", :force => true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "courses_students", ["course_id"], :name => "index_courses_students_on_course_id"
  add_index "courses_students", ["user_id"], :name => "index_courses_students_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "submissions", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.integer  "assignment_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "submissions", ["assignment_id"], :name => "index_submissions_on_assignment_id"

  create_table "users", :force => true do |t|
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
    t.string   "name"
    t.string   "role"
    t.integer  "organization_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
