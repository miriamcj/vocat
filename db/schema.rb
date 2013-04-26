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

ActiveRecord::Schema.define(:version => 20130425183704) do

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

  create_table "courses_assistants", :force => true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "courses_assistants", ["course_id"], :name => "index_courses_assistants_on_course_id"
  add_index "courses_assistants", ["user_id"], :name => "index_courses_assistants_on_user_id"

  create_table "courses_creators", :force => true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "courses_creators", ["course_id"], :name => "index_courses_creators_on_course_id"
  add_index "courses_creators", ["user_id"], :name => "index_courses_creators_on_user_id"

  create_table "courses_evaluators", :force => true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "courses_evaluators", ["course_id"], :name => "index_courses_evaluators_on_course_id"
  add_index "courses_evaluators", ["user_id"], :name => "index_courses_evaluators_on_user_id"

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

  create_table "evaluations", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "evaluator_id"
    t.hstore   "scores"
    t.boolean  "published"
    t.integer  "rubric_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "evaluations", ["scores"], :name => "index_evaluations_on_scores"

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "course_id"
    t.integer  "project_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "rubric_id"
  end

  add_index "projects", ["course_id"], :name => "index_projects_on_course_id"
  add_index "projects", ["project_type_id"], :name => "index_projects_on_project_type_id"

  create_table "rubrics", :force => true do |t|
    t.string   "name"
    t.boolean  "public"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "fields"
    t.text     "ranges"
    t.integer  "owner_id"
    t.text     "description"
    t.integer  "organization_id"
    t.integer  "course_id"
    t.hstore   "field_sorting"
    t.hstore   "field_descriptions"
    t.hstore   "range_lows"
    t.hstore   "range_highs"
    t.hstore   "range_descriptions"
  end

  add_index "rubrics", ["field_descriptions"], :name => "index_rubrics_on_field_descriptions"
  add_index "rubrics", ["field_sorting"], :name => "index_rubrics_on_field_sorting"
  add_index "rubrics", ["range_descriptions"], :name => "index_rubrics_on_range_descriptions"
  add_index "rubrics", ["range_highs"], :name => "index_rubrics_on_range_highs"
  add_index "rubrics", ["range_lows"], :name => "index_rubrics_on_range_lows"

  create_table "submissions", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.integer  "project_id"
    t.integer  "creator_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "submissions", ["creator_id"], :name => "index_submissions_on_creator_id"
  add_index "submissions", ["project_id"], :name => "index_submissions_on_project_id"

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

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
