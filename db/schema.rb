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

ActiveRecord::Schema.define(version: 20140711181743) do

  create_table "bits_interpreters", force: true do |t|
    t.string   "name",        null: false
    t.integer  "length",      null: false
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "bits_segments", force: true do |t|
    t.integer  "bits_interpreter_id", null: false
    t.string   "name",                null: false
    t.integer  "start_bit",           null: false
    t.integer  "end_bit",             null: false
    t.string   "description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "bits_values", force: true do |t|
    t.integer  "bits_segment_id", null: false
    t.string   "bits",            null: false
    t.string   "description",     null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "bug_configs", force: true do |t|
    t.integer  "test_target_id", null: false
    t.string   "url",            null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "bug_tracks", force: true do |t|
    t.integer  "test_target_id", null: false
    t.integer  "bug_id",         null: false
    t.integer  "test_case_id",   null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "bug_tracks", ["test_case_id", "bug_id"], name: "index2", unique: true, using: :btree

  create_table "change_lists", force: true do |t|
    t.string "description"
  end

  create_table "members", force: true do |t|
    t.string   "name",            null: false
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "hashed_password", null: false
    t.integer  "picture_id"
  end

  add_index "members", ["name"], name: "name", unique: true, using: :btree

  create_table "members_projects", id: false, force: true do |t|
    t.integer "member_id",  null: false
    t.integer "project_id", null: false
  end

  add_index "members_projects", ["project_id", "member_id"], name: "index_by_project_and_member", using: :btree

  create_table "pictures", force: true do |t|
    t.string   "content_type", null: false
    t.binary   "data",         null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "projects", force: true do |t|
    t.string   "name",       null: false
    t.integer  "created_by", null: false
    t.integer  "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "projects", ["name"], name: "name", unique: true, using: :btree

  create_table "sessions", force: true do |t|
    t.string   "session_id",                    null: false
    t.text     "data",       limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "test_case_template_params", force: true do |t|
    t.string  "name",                              null: false
    t.integer "test_case_template_id"
    t.integer "seq",                   default: 0
  end

  add_index "test_case_template_params", ["name"], name: "index1", using: :btree
  add_index "test_case_template_params", ["test_case_template_id", "id"], name: "index3", using: :btree
  add_index "test_case_template_params", ["test_case_template_id", "name"], name: "index2", using: :btree
  add_index "test_case_template_params", ["test_case_template_id"], name: "index0", using: :btree

  create_table "test_case_templates", force: true do |t|
    t.string   "name",           null: false
    t.integer  "test_target_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "test_case_templates", ["name"], name: "index1", using: :btree
  add_index "test_case_templates", ["test_target_id", "id", "name"], name: "index3", using: :btree
  add_index "test_case_templates", ["test_target_id", "name"], name: "index2", using: :btree
  add_index "test_case_templates", ["test_target_id"], name: "index0", using: :btree

  create_table "test_case_test_case_template_param_instance_associations", force: true do |t|
    t.integer "test_case_id",                         null: false
    t.integer "test_case_template_param_instance_id", null: false
  end

  add_index "test_case_test_case_template_param_instance_associations", ["test_case_id", "test_case_template_param_instance_id"], name: "index2", using: :btree
  add_index "test_case_test_case_template_param_instance_associations", ["test_case_id"], name: "index0", using: :btree
  add_index "test_case_test_case_template_param_instance_associations", ["test_case_template_param_instance_id", "test_case_id", "id"], name: "index3", using: :btree
  add_index "test_case_test_case_template_param_instance_associations", ["test_case_template_param_instance_id"], name: "index1", using: :btree

  create_table "test_cases", force: true do |t|
    t.string  "name",                            null: false
    t.integer "test_target_id",                  null: false
    t.integer "test_execution_time"
    t.integer "version",             default: 1
    t.integer "next_test_case_id"
    t.integer "first_test_case_id"
  end

  add_index "test_cases", ["name"], name: "index_by_name", using: :btree
  add_index "test_cases", ["test_target_id", "name"], name: "index_by_test_target_and_name", using: :btree
  add_index "test_cases", ["test_target_id"], name: "test_target_id", using: :btree

  create_table "test_cases_suites", id: false, force: true do |t|
    t.integer "test_suite_id", null: false
    t.integer "test_case_id",  null: false
  end

  add_index "test_cases_suites", ["test_case_id"], name: "index_test_cases_suites_on_test_case_id", using: :btree
  add_index "test_cases_suites", ["test_case_id"], name: "test_case_id", using: :btree
  add_index "test_cases_suites", ["test_suite_id"], name: "index_test_cases_suites_on_test_suite_id", using: :btree
  add_index "test_cases_suites", ["test_suite_id"], name: "test_suite_id", using: :btree

  create_table "test_results", force: true do |t|
    t.integer  "test_case_id",                        null: false
    t.datetime "updated_at",                          null: false
    t.datetime "created_at",                          null: false
    t.integer  "test_target_instance_id",             null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "value",                   default: 0
    t.float    "result"
  end

  add_index "test_results", ["test_case_id", "test_target_instance_id"], name: "index_test_case_id_and_test_target_instance_id", using: :btree
  add_index "test_results", ["test_target_instance_id", "test_case_id"], name: "index_by_test_target_instance_and_test_case", using: :btree

  create_table "test_suite_test_suite_associations", force: true do |t|
    t.integer  "parent_test_suite_id", null: false
    t.integer  "child_test_suite_id",  null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "test_suites", force: true do |t|
    t.string   "name",           null: false
    t.integer  "test_target_id", null: false
    t.datetime "updated_at",     null: false
    t.datetime "created_at",     null: false
  end

  create_table "test_target_instances", force: true do |t|
    t.string   "name",           null: false
    t.integer  "change_list_id", null: false
    t.integer  "test_target_id", null: false
    t.datetime "updated_at",     null: false
    t.datetime "created_at",     null: false
    t.integer  "created_by"
    t.integer  "updated_by"
  end

  add_index "test_target_instances", ["test_target_id"], name: "index_by_test_target", using: :btree

  create_table "test_targets", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
  end

  add_index "test_targets", ["name"], name: "name", unique: true, using: :btree

  create_table "weighted_test_results", force: true do |t|
    t.integer "test_case_id",                        null: false
    t.integer "test_target_instance_id",             null: false
    t.integer "value",                   default: 0
  end

  add_index "weighted_test_results", ["test_case_id", "test_target_instance_id"], name: "index_test_case_id_and_test_target_instance_id", unique: true, using: :btree
  add_index "weighted_test_results", ["test_case_id"], name: "incex_target_cycle_created_caseid", using: :btree
  add_index "weighted_test_results", ["test_case_id"], name: "index_type_cycle_case", using: :btree
  add_index "weighted_test_results", ["test_case_id"], name: "test_case_id", using: :btree
  add_index "weighted_test_results", ["test_target_instance_id", "test_case_id"], name: "index_by_test_target_instance_and_test_case", using: :btree

end
