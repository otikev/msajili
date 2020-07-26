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

ActiveRecord::Schema.define(version: 20150920190958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_levels", force: true do |t|
    t.string "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "academic_qualifications", force: true do |t|
    t.string "institution"
    t.string "award"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "academic_level_id"
    t.date "start_date"
    t.date "end_date"
  end

  create_table "administrators", force: true do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "password_hash"
    t.string "password_salt"
    t.string "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "role", default: 1
    t.boolean "enabled", default: true
  end

  create_table "agent_requests", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: true do |t|
    t.text "content"
    t.integer "question_id"
    t.integer "application_id"
    t.integer "choice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "filter_id"
  end

  create_table "applications", force: true do |t|
    t.text "cover_letter"
    t.integer "job_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "status"
    t.integer "stage_id"
    t.boolean "dropped", default: false
  end

  add_index "applications", ["job_id", "user_id"], name: "index_applications_on_job_id_and_user_id", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "choices", force: true do |t|
    t.text "content"
    t.integer "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text "message"
    t.integer "application_id"
    t.integer "user_id"
    t.integer "stage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commissions", force: true do |t|
    t.float "amount"
    t.integer "sales_agent_id"
    t.integer "payment_id"
    t.integer "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string "name"
    t.text "about"
    t.string "phone"
    t.string "country"
    t.string "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "website"
    t.integer "package"
    t.integer "trial_used", default: 0
    t.string "referral_id"
    t.string "identifier"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "employers", force: true do |t|
    t.string "name"
    t.date "from"
    t.date "to"
    t.string "position_held"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filters", force: true do |t|
    t.string "title"
    t.integer "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interviews", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "location"
    t.text "additional_info"
    t.text "comments"
    t.integer "user_id"
    t.integer "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_fields", force: true do |t|
    t.string "title"
    t.text "content"
    t.integer "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position"
  end

  create_table "job_stat_logs", force: true do |t|
    t.integer "job_stat_id"
    t.string "ip_address"
    t.text "cookie"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_stats", force: true do |t|
    t.integer "views", default: 0
    t.integer "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "popularity", default: 0
  end

  create_table "jobs", force: true do |t|
    t.string "title"
    t.date "deadline"
    t.string "country"
    t.string "city"
    t.integer "company_id"
    t.integer "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "token"
    t.integer "status"
    t.integer "user_id"
    t.integer "procedure_id"
    t.integer "paid_on_demand", default: 0
    t.integer "job_type", default: 0
    t.string "company_name"
    t.text "source"
  end

  add_index "jobs", ["user_id"], name: "index_jobs_on_user_id", using: :btree

  create_table "password_requests", force: true do |t|
    t.string "token"
    t.datetime "expiry"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.string "description"
    t.integer "quantity"
    t.integer "package"
    t.integer "status"
    t.integer "total"
    t.string "pesapal_transaction_tracking_id"
    t.string "pesapal_merchant_reference"
    t.integer "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedures", force: true do |t|
    t.string "title"
    t.integer "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.text "content"
    t.integer "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "template_id"
    t.integer "position"
    t.integer "question_type"
  end

  create_table "referees", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "company"
    t.string "title"
    t.string "email"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "position"
  end

  create_table "responsibilities", force: true do |t|
    t.text "description"
    t.integer "employer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_agents", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "auth_token"
    t.string "password_hash"
    t.string "password_salt"
    t.string "referral_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "phone"
  end

  create_table "scheduler_logs", force: true do |t|
    t.string "scheduler"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stages", force: true do |t|
    t.integer "position"
    t.string "title"
    t.text "description"
    t.integer "procedure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stages", ["procedure_id", "position"], name: "index_stages_on_procedure_id_and_position", unique: true, using: :btree

  create_table "sync_logs", force: true do |t|
    t.integer "record_type"
    t.integer "record_id"
    t.integer "log_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", force: true do |t|
    t.string "title"
    t.integer "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tokens", force: true do |t|
    t.integer "jobs"
    t.date "expiry"
    t.integer "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", force: true do |t|
    t.integer "upload_type"
    t.string "description"
    t.string "url"
    t.string "file"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "application_id"
  end

  create_table "users", force: true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "country"
    t.string "city"
    t.string "password_hash"
    t.string "password_salt"
    t.string "auth_token"
    t.integer "company_id"
    t.integer "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "activated", default: false
    t.string "activation_token"
    t.date "expiry"
    t.boolean "enabled", default: false
  end

end
