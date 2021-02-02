# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2015_09_20_190958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_levels", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "academic_qualifications", force: :cascade do |t|
    t.string "institution"
    t.string "award"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "academic_level_id"
    t.date "start_date"
    t.date "end_date"
    t.index ["academic_level_id"], name: "index_academic_qualifications_on_academic_level_id"
    t.index ["user_id"], name: "index_academic_qualifications_on_user_id"
  end

  create_table "administrators", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "password_hash"
    t.string "password_salt"
    t.string "auth_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 1
    t.boolean "enabled", default: true
  end

  create_table "agent_requests", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "answers", force: :cascade do |t|
    t.text "content"
    t.bigint "question_id"
    t.bigint "application_id"
    t.bigint "choice_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "filter_id"
    t.index ["application_id"], name: "index_answers_on_application_id"
    t.index ["choice_id"], name: "index_answers_on_choice_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "applications", force: :cascade do |t|
    t.text "cover_letter"
    t.bigint "job_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
    t.integer "stage_id"
    t.boolean "dropped", default: false
    t.index ["job_id", "user_id"], name: "index_applications_on_job_id_and_user_id", unique: true
    t.index ["job_id"], name: "index_applications_on_job_id"
    t.index ["user_id"], name: "index_applications_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "choices", force: :cascade do |t|
    t.text "content"
    t.bigint "question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_choices_on_question_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "message"
    t.bigint "application_id"
    t.bigint "user_id"
    t.bigint "stage_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_comments_on_application_id"
    t.index ["stage_id"], name: "index_comments_on_stage_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "commissions", force: :cascade do |t|
    t.float "amount"
    t.bigint "sales_agent_id"
    t.bigint "payment_id"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_commissions_on_company_id"
    t.index ["payment_id"], name: "index_commissions_on_payment_id"
    t.index ["sales_agent_id"], name: "index_commissions_on_sales_agent_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.text "about"
    t.string "phone"
    t.string "country"
    t.string "city"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "website"
    t.integer "package"
    t.integer "trial_used", default: 0
    t.string "referral_id"
    t.string "identifier"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "employers", force: :cascade do |t|
    t.string "name"
    t.date "from"
    t.date "to"
    t.string "position_held"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_employers_on_user_id"
  end

  create_table "filters", force: :cascade do |t|
    t.string "title"
    t.bigint "job_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_id"], name: "index_filters_on_job_id"
  end

  create_table "interviews", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "location"
    t.text "additional_info"
    t.text "comments"
    t.bigint "user_id"
    t.bigint "application_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["application_id"], name: "index_interviews_on_application_id"
    t.index ["user_id"], name: "index_interviews_on_user_id"
  end

  create_table "job_fields", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "job_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position"
    t.index ["job_id"], name: "index_job_fields_on_job_id"
  end

  create_table "job_stat_logs", force: :cascade do |t|
    t.bigint "job_stat_id"
    t.string "ip_address"
    t.text "cookie"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["job_stat_id"], name: "index_job_stat_logs_on_job_stat_id"
  end

  create_table "job_stats", force: :cascade do |t|
    t.integer "views", default: 0
    t.bigint "job_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "popularity", default: 0
    t.index ["job_id"], name: "index_job_stats_on_job_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.date "deadline"
    t.string "country"
    t.string "city"
    t.bigint "company_id"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.integer "status"
    t.integer "user_id"
    t.integer "procedure_id"
    t.integer "paid_on_demand", default: 0
    t.integer "job_type", default: 0
    t.string "company_name"
    t.text "source"
    t.index ["category_id"], name: "index_jobs_on_category_id"
    t.index ["company_id"], name: "index_jobs_on_company_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "password_requests", force: :cascade do |t|
    t.string "token"
    t.datetime "expiry"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_password_requests_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "description"
    t.integer "quantity"
    t.integer "package"
    t.integer "status"
    t.integer "total"
    t.string "pesapal_transaction_tracking_id"
    t.string "pesapal_merchant_reference"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_payments_on_company_id"
  end

  create_table "procedures", force: :cascade do |t|
    t.string "title"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_procedures_on_company_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "content"
    t.bigint "job_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "template_id"
    t.integer "position"
    t.integer "question_type", default: 0
    t.index ["job_id"], name: "index_questions_on_job_id"
  end

  create_table "referees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "company"
    t.string "title"
    t.string "email"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "position"
    t.index ["user_id"], name: "index_referees_on_user_id"
  end

  create_table "responsibilities", force: :cascade do |t|
    t.text "description"
    t.bigint "employer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employer_id"], name: "index_responsibilities_on_employer_id"
  end

  create_table "sales_agents", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "auth_token"
    t.string "password_hash"
    t.string "password_salt"
    t.string "referral_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone"
  end

  create_table "scheduler_logs", force: :cascade do |t|
    t.string "scheduler"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stages", force: :cascade do |t|
    t.integer "position"
    t.string "title"
    t.text "description"
    t.bigint "procedure_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["procedure_id", "position"], name: "index_stages_on_procedure_id_and_position", unique: true
    t.index ["procedure_id"], name: "index_stages_on_procedure_id"
  end

  create_table "sync_logs", force: :cascade do |t|
    t.integer "record_type"
    t.integer "record_id"
    t.integer "log_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "title"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_templates_on_company_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "jobs"
    t.date "expiry"
    t.bigint "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_tokens_on_company_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.integer "upload_type"
    t.string "description"
    t.string "url"
    t.string "file"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "application_id"
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "country"
    t.string "city"
    t.string "password_hash"
    t.string "password_salt"
    t.string "auth_token"
    t.bigint "company_id"
    t.bigint "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "activated", default: false
    t.string "activation_token"
    t.date "expiry"
    t.boolean "enabled", default: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["role"], name: "index_users_on_role"
  end

end
