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

ActiveRecord::Schema.define(version: 20150701210454) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "annotations", force: :cascade do |t|
    t.text     "body"
    t.string   "smpte_timecode",   limit: 255
    t.boolean  "published"
    t.float    "seconds_timecode"
    t.integer  "author_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
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
    t.string   "location",        limit: 255
    t.string   "format",          limit: 255
    t.string   "state",           limit: 255
    t.string   "processor_name",  limit: 255
    t.text     "processor_data"
    t.string   "processor_error", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "file_size"
    t.decimal  "duration"
    t.integer  "width"
    t.integer  "height"
    t.boolean  "metadata_saved",              default: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "media_file_name",     limit: 255
    t.string   "media_content_type",  limit: 255
    t.integer  "media_file_size"
    t.datetime "media_updated_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "state",               limit: 255
    t.string   "processor_error",     limit: 255
    t.integer  "user_id"
    t.string   "processed_key",       limit: 255
    t.string   "processor_job_id",    limit: 255
    t.string   "processor_class",     limit: 255
    t.string   "processed_thumb_key", limit: 255
    t.hstore   "processing_data"
    t.integer  "asset_id"
  end

  create_table "course_requests", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "department",   limit: 255
    t.string   "section",      limit: 255
    t.string   "number",       limit: 255
    t.integer  "year"
    t.integer  "semester_id"
    t.integer  "evaluator_id"
    t.string   "state",        limit: 255
    t.integer  "admin_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "department",      limit: 255
    t.string   "number",          limit: 255
    t.string   "section",         limit: 255
    t.text     "description"
    t.integer  "organization_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "message"
    t.integer  "semester_id"
    t.integer  "year"
  end

  add_index "courses", ["organization_id"], name: "index_courses_on_organization_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0
    t.integer  "attempts",               default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

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
    t.decimal  "total_percentage", default: 0.0
    t.decimal  "total_score",      default: 0.0
    t.integer  "evaluation_type"
  end

  add_index "evaluations", ["scores"], name: "index_evaluations_on_scores", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "course_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "groups_creators", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "role",       limit: 255
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
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                              limit: 255
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.string   "subdomain"
    t.boolean  "active"
    t.string   "logo"
    t.boolean  "ldap_enabled",                                  default: false
    t.string   "ldap_host"
    t.string   "ldap_encryption",                               default: "simple_tls"
    t.integer  "ldap_port",                                     default: 3269
    t.string   "ldap_filter_dn"
    t.string   "ldap_filter",                                   default: "(mail={email})"
    t.string   "ldap_bind_dn"
    t.string   "ldap_bind_cn"
    t.string   "ldap_bind_password"
    t.string   "ldap_org_identity",                             default: "name"
    t.string   "ldap_reset_pw_url"
    t.string   "ldap_recover_pw_url"
    t.text     "ldap_message"
    t.string   "ldap_evaluator_email_domain"
    t.string   "ldap_default_role",                             default: "creator"
    t.string   "email_default_from"
    t.string   "email_notification_course_request"
  end

  create_table "project_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",                        limit: 255
    t.text     "description"
    t.integer  "course_id"
    t.integer  "project_type_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "rubric_id"
    t.integer  "listing_order"
    t.string   "type",                        limit: 255, default: "user"
    t.date     "due_date"
    t.text     "allowed_attachment_families",             default: [],                  array: true
    t.hstore   "settings",                                default: {},     null: false
  end

  add_index "projects", ["course_id"], name: "index_projects_on_course_id", using: :btree
  add_index "projects", ["project_type_id"], name: "index_projects_on_project_type_id", using: :btree

  create_table "rubrics", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.boolean  "public"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
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
    t.string   "name",       limit: 255
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.text     "summary"
    t.integer  "project_id"
    t.integer  "creator_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.boolean  "published"
    t.integer  "discussion_posts_count",             default: 0
    t.string   "creator_type",           limit: 255, default: "User"
    t.integer  "assets_count",                       default: 0
  end

  add_index "submissions", ["creator_id"], name: "index_submissions_on_creator_id", using: :btree
  add_index "submissions", ["project_id"], name: "index_submissions_on_project_id", using: :btree

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
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "role",                   limit: 255
    t.integer  "organization_id"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "middle_name",            limit: 255
    t.text     "settings"
    t.string   "org_identity",           limit: 255
    t.string   "gender",                 limit: 255
    t.string   "city",                   limit: 255
    t.string   "state",                  limit: 255
    t.string   "country",                limit: 255
    t.boolean  "is_ldap_user"
    t.hstore   "preferences",                        default: {}, null: false
  end

  add_index "users", ["email", "organization_id"], name: "index_users_on_email_and_organization_id", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255, null: false
    t.integer  "item_id",                null: false
    t.string   "event",      limit: 255, null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
