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

ActiveRecord::Schema.define(version: 20141211170000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "annotations", force: true do |t|
    t.text     "body"
    t.string   "smpte_timecode"
    t.boolean  "published"
    t.float    "seconds_timecode"
    t.integer  "author_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "video_id"
  end

  create_table "attachment_variants", force: true do |t|
    t.integer  "attachment_id"
    t.string   "location"
    t.string   "format"
    t.string   "state"
    t.string   "processor_name"
    t.text     "processor_data"
    t.string   "processor_error"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: true do |t|
    t.string   "media_file_name"
    t.string   "media_content_type"
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "state"
    t.integer  "video_id"
    t.string   "processor_error"
    t.integer  "user_id"
    t.string   "processed_key"
    t.string   "processor_job_id"
    t.string   "processor_class"
    t.string   "processed_thumb_key"
    t.hstore   "processing_data"
  end

  create_table "course_requests", force: true do |t|
    t.string   "name"
    t.string   "department"
    t.string   "section"
    t.string   "number"
    t.integer  "year"
    t.integer  "semester_id"
    t.integer  "evaluator_id"
    t.string   "state"
    t.integer  "admin_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "name"
    t.string   "department"
    t.string   "number"
    t.string   "section"
    t.text     "description"
    t.integer  "organization_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.hstore   "settings",        default: {}, null: false
    t.text     "message"
    t.integer  "semester_id"
    t.integer  "year"
  end

  add_index "courses", ["organization_id"], name: "index_courses_on_organization_id", using: :btree

  create_table "courses_assistants_to_be_deleted", force: true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "courses_assistants_to_be_deleted", ["course_id"], name: "index_courses_assistants_to_be_deleted_on_course_id", using: :btree
  add_index "courses_assistants_to_be_deleted", ["user_id"], name: "index_courses_assistants_to_be_deleted_on_user_id", using: :btree

  create_table "courses_creators_to_be_deleted", force: true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "courses_creators_to_be_deleted", ["course_id"], name: "index_courses_creators_to_be_deleted_on_course_id", using: :btree
  add_index "courses_creators_to_be_deleted", ["user_id"], name: "index_courses_creators_to_be_deleted_on_user_id", using: :btree

  create_table "courses_evaluators_to_be_deleted", force: true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_index "courses_evaluators_to_be_deleted", ["course_id"], name: "index_courses_evaluators_to_be_deleted_on_course_id", using: :btree
  add_index "courses_evaluators_to_be_deleted", ["user_id"], name: "index_courses_evaluators_to_be_deleted_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "discussion_posts", force: true do |t|
    t.boolean  "published"
    t.integer  "author_id"
    t.integer  "parent_id"
    t.text     "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "submission_id"
  end

  create_table "evaluations", force: true do |t|
    t.integer  "submission_id"
    t.integer  "evaluator_id"
    t.hstore   "scores",           default: {},    null: false
    t.boolean  "published",        default: false
    t.integer  "rubric_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.decimal  "total_percentage", default: 0.0
    t.decimal  "total_score",      default: 0.0
    t.integer  "evaluation_type"
  end

  add_index "evaluations", ["scores"], name: "index_evaluations_on_scores", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_creators", id: false, force: true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "course_id"
    t.integer  "project_type_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "rubric_id"
    t.integer  "listing_order"
    t.string   "type",            default: "user"
    t.date     "due_date"
  end

  add_index "projects", ["course_id"], name: "index_projects_on_course_id", using: :btree
  add_index "projects", ["project_type_id"], name: "index_projects_on_project_type_id", using: :btree

  create_table "rubrics", force: true do |t|
    t.string   "name"
    t.boolean  "public"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "owner_id"
    t.text     "description"
    t.integer  "organization_id"
    t.integer  "course_id"
    t.text     "cells"
    t.text     "fields"
    t.text     "ranges"
    t.integer  "high"
    t.integer  "low"
  end

  create_table "semesters", force: true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", force: true do |t|
    t.string   "name"
    t.text     "summary"
    t.integer  "project_id"
    t.integer  "creator_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "published"
    t.integer  "discussion_posts_count", default: 0
    t.string   "creator_type",           default: "User"
  end

  add_index "submissions", ["creator_id"], name: "index_submissions_on_creator_id", using: :btree
  add_index "submissions", ["project_id"], name: "index_submissions_on_project_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role"
    t.integer  "organization_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.text     "settings"
    t.string   "org_identity"
    t.string   "gender"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.boolean  "is_ldap_user"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "videos", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "source_id"
    t.string   "source_url"
    t.string   "source"
    t.integer  "submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_url"
  end

end
