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

ActiveRecord::Schema.define(version: 20170109173626) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "annotations", force: :cascade do |t|
    t.text     "body"
    t.string   "smpte_timecode"
    t.boolean  "published"
    t.float    "seconds_timecode"
    t.integer  "author_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "asset_id"
    t.text     "canvas"
  end

  create_table "assets", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "author_id"
    t.integer  "submission_id"
    t.integer  "listing_order"
    t.string   "external_location"
    t.string   "external_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachment_variants", force: :cascade do |t|
    t.integer  "attachment_id"
    t.string   "location"
    t.string   "format"
    t.string   "state"
    t.string   "processor_name"
    t.text     "processor_data"
    t.string   "processor_error"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "file_size"
    t.decimal  "duration"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "metadata_saved",  default: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "media_file_name"
    t.string   "media_content_type"
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "state"
    t.string   "processor_error"
    t.integer  "user_id"
    t.string   "processed_key"
    t.string   "processor_job_id"
    t.string   "processor_class"
    t.string   "processed_thumb_key"
    t.hstore   "processing_data"
    t.integer  "asset_id"
  end

  create_table "course_events", force: :cascade do |t|
    t.string   "event_type"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loggable_id"
    t.string   "loggable_type"
    t.integer  "submission_id"
    t.index ["loggable_type", "loggable_id"], name: "index_course_events_on_loggable_type_and_loggable_id", using: :btree
  end

  create_table "course_requests", force: :cascade do |t|
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
    t.integer  "organization_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "department"
    t.string   "number"
    t.string   "section"
    t.text     "description"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "message"
    t.integer  "semester_id"
    t.integer  "year"
    t.index ["organization_id"], name: "index_courses_on_organization_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
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
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "discussion_posts", force: :cascade do |t|
    t.boolean  "published"
    t.integer  "author_id"
    t.integer  "parent_id"
    t.text     "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "submission_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer  "submission_id"
    t.integer  "evaluator_id"
    t.hstore   "scores",           default: {},    null: false
    t.boolean  "published",        default: false
    t.integer  "rubric_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.decimal  "total_percentage", default: "0.0"
    t.decimal  "total_score",      default: "0.0"
    t.integer  "evaluation_type"
    t.index ["scores"], name: "index_evaluations_on_scores", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_creators", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "subdomain"
    t.boolean  "active"
    t.string   "logo"
    t.boolean  "ldap_enabled",                      default: false
    t.string   "ldap_host"
    t.string   "ldap_encryption",                   default: "simple_tls"
    t.integer  "ldap_port",                         default: 3269
    t.string   "ldap_filter_dn"
    t.string   "ldap_filter",                       default: "(mail={email})"
    t.string   "ldap_bind_dn"
    t.string   "ldap_bind_cn"
    t.string   "ldap_bind_password"
    t.string   "ldap_org_identity",                 default: "name"
    t.string   "ldap_reset_pw_url"
    t.string   "ldap_recover_pw_url"
    t.text     "ldap_message"
    t.string   "ldap_evaluator_email_domain"
    t.string   "ldap_default_role",                 default: "creator"
    t.string   "email_default_from"
    t.string   "email_notification_course_request"
    t.string   "support_email"
  end

  create_table "project_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "course_id"
    t.integer  "project_type_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "rubric_id"
    t.integer  "listing_order"
    t.string   "type",                        default: "UserProject"
    t.date     "due_date"
    t.text     "allowed_attachment_families", default: [],                         array: true
    t.hstore   "settings",                    default: {},            null: false
    t.index ["course_id"], name: "index_projects_on_course_id", using: :btree
    t.index ["project_type_id"], name: "index_projects_on_project_type_id", using: :btree
  end

  create_table "rubrics", force: :cascade do |t|
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

  create_table "semesters", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "name"
    t.text     "summary"
    t.integer  "project_id"
    t.integer  "creator_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "published"
    t.integer  "discussion_posts_count", default: 0
    t.string   "creator_type",           default: "User"
    t.integer  "assets_count",           default: 0
    t.index ["creator_id"], name: "index_submissions_on_creator_id", using: :btree
    t.index ["project_id"], name: "index_submissions_on_project_id", using: :btree
  end

  create_table "tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "refresh_count", default: 0
    t.string   "ip_address"
    t.string   "client"
    t.datetime "last_seen_at"
    t.datetime "expires_at"
    t.string   "token"
  end

  create_table "users", force: :cascade do |t|
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
    t.hstore   "preferences",            default: {}, null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["email", "organization_id"], name: "index_users_on_email_and_organization_id", unique: true, using: :btree
    t.index ["organization_id"], name: "index_users_on_organization_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "visitable_course_id"
    t.integer  "visitable_id"
    t.string   "visitable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["visitable_course_id"], name: "index_visits_on_visitable_course_id", using: :btree
    t.index ["visitable_type", "visitable_id"], name: "index_visits_on_visitable_type_and_visitable_id", using: :btree
  end

end
