# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130430074114) do

  create_table "az_activities", :force => true do |t|
    t.string   "action",      :null => false
    t.string   "model_name",  :null => false
    t.string   "object_name"
    t.integer  "model_id",    :null => false
    t.integer  "owner_id",    :null => false
    t.integer  "user_id",     :null => false
    t.integer  "project_id"
    t.datetime "created_at"
  end

  add_index "az_activities", ["created_at"], :name => "index_az_activities_on_created_at"
  add_index "az_activities", ["owner_id"], :name => "index_az_activities_on_owner_id"
  add_index "az_activities", ["project_id"], :name => "index_az_activities_on_project_id"
  add_index "az_activities", ["user_id"], :name => "index_az_activities_on_user_id"

  create_table "az_activity_fields", :force => true do |t|
    t.integer "az_activity_id", :null => false
    t.string  "field",          :null => false
    t.text    "old_value"
    t.text    "new_value"
  end

  add_index "az_activity_fields", ["az_activity_id"], :name => "index_az_activity_fields_on_az_activity_id"

  create_table "az_allowed_operations", :force => true do |t|
    t.integer  "az_typed_page_id"
    t.integer  "az_operation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",         :null => false
    t.integer  "copy_of"
  end

  add_index "az_allowed_operations", ["copy_of"], :name => "index_az_allowed_operations_on_copy_of"

  create_table "az_articles", :force => true do |t|
    t.string   "title"
    t.text     "announce"
    t.text     "text"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_balance_transactions", :force => true do |t|
    t.integer  "az_company_id",                                :null => false
    t.string   "description"
    t.decimal  "amount",        :precision => 20, :scale => 2, :null => false
    t.integer  "az_invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "az_balance_transactions", ["az_company_id"], :name => "index_az_balance_transactions_on_az_company_id"

  create_table "az_base_data_types", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "az_base_data_type_id"
    t.integer  "az_collection_template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "copy_of"
    t.integer  "owner_id",                                 :null => false
    t.boolean  "seed"
    t.integer  "az_base_project_id"
    t.text     "description",                              :null => false
    t.integer  "status",                    :default => 0, :null => false
    t.integer  "position",                                 :null => false
    t.integer  "tr_position"
  end

  add_index "az_base_data_types", ["az_base_data_type_id"], :name => "az_base_data_type_id"
  add_index "az_base_data_types", ["az_base_data_type_id"], :name => "index_az_base_data_types_on_az_base_data_type_id"
  add_index "az_base_data_types", ["az_base_project_id"], :name => "index_az_base_data_types_on_az_base_project_id"
  add_index "az_base_data_types", ["copy_of"], :name => "index_az_base_data_types_on_copy_of"
  add_index "az_base_data_types", ["owner_id"], :name => "index_az_base_data_types_on_owner_id"

  create_table "az_base_project_stats", :force => true do |t|
    t.integer  "az_base_project_id"
    t.integer  "components_num"
    t.integer  "pages_num"
    t.integer  "pages_words_num"
    t.integer  "commons_num"
    t.integer  "commons_words_num"
    t.integer  "definitions_num"
    t.integer  "definitions_words_num"
    t.integer  "structs_num"
    t.integer  "structs_variables_num"
    t.integer  "design_sources_num"
    t.integer  "designs_num"
    t.integer  "images_num"
    t.integer  "words_num"
    t.integer  "disk_usage"
    t.float    "quality"
    t.integer  "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commons_common_num"
    t.integer  "commons_acceptance_condition_num"
    t.integer  "commons_content_creation_num"
    t.integer  "commons_purpose_exploitation_num"
    t.integer  "commons_purpose_functional_num"
    t.integer  "commons_requirements_hosting_num"
    t.integer  "commons_requirements_reliability_num"
    t.integer  "commons_functionality_num"
  end

  add_index "az_base_project_stats", ["az_base_project_id"], :name => "index_az_base_project_stats_on_az_base_project_id"
  add_index "az_base_project_stats", ["commons_num"], :name => "index_az_base_project_stats_on_commons_num"
  add_index "az_base_project_stats", ["components_num"], :name => "index_az_base_project_stats_on_components_num"
  add_index "az_base_project_stats", ["definitions_num"], :name => "index_az_base_project_stats_on_definitions_num"
  add_index "az_base_project_stats", ["design_sources_num"], :name => "index_az_base_project_stats_on_design_sources_num"
  add_index "az_base_project_stats", ["designs_num"], :name => "index_az_base_project_stats_on_designs_num"
  add_index "az_base_project_stats", ["disk_usage"], :name => "index_az_base_project_stats_on_disk_usage"
  add_index "az_base_project_stats", ["images_num"], :name => "index_az_base_project_stats_on_images_num"
  add_index "az_base_project_stats", ["pages_num"], :name => "index_az_base_project_stats_on_pages_num"
  add_index "az_base_project_stats", ["quality"], :name => "index_az_base_project_stats_on_quality"
  add_index "az_base_project_stats", ["structs_num"], :name => "index_az_base_project_stats_on_structs_num"
  add_index "az_base_project_stats", ["structs_variables_num"], :name => "index_az_base_project_stats_on_structs_variables_num"
  add_index "az_base_project_stats", ["words_num"], :name => "index_az_base_project_stats_on_words_num"

  create_table "az_base_projects", :force => true do |t|
    t.string   "name",                                    :null => false
    t.string   "customer"
    t.string   "favicon_file_name"
    t.string   "favicon_content_type"
    t.integer  "favicon_file_size"
    t.datetime "favicon_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.integer  "author_id"
    t.integer  "rm_id"
    t.string   "type"
    t.float    "layout_time",          :default => 0.0
    t.integer  "copy_of"
    t.float    "percent_complete",     :default => 0.0,   :null => false
    t.integer  "az_project_status_id", :default => 1,     :null => false
    t.integer  "disk_usage",           :default => 0,     :null => false
    t.boolean  "seed"
    t.integer  "position"
    t.boolean  "public_access",        :default => false, :null => false
    t.integer  "parent_project_id"
    t.boolean  "deleting",             :default => false
    t.boolean  "cache",                :default => false, :null => false
    t.boolean  "explorable",           :default => true
    t.boolean  "forkable",             :default => true
    t.float    "quality_correction",   :default => 1.0
  end

  add_index "az_base_projects", ["owner_id"], :name => "index_az_base_projects_on_owner_id"
  add_index "az_base_projects", ["parent_project_id"], :name => "index_az_base_projects_on_parent_project_id"

  create_table "az_base_projects_az_definitions", :force => true do |t|
    t.integer  "az_base_project_id"
    t.integer  "az_definition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",           :null => false
  end

  create_table "az_bills", :force => true do |t|
    t.integer  "az_invoice_id",                                :null => false
    t.text     "description"
    t.datetime "date_from"
    t.datetime "date_till"
    t.decimal  "fee",           :precision => 20, :scale => 2, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "az_bills", ["az_invoice_id"], :name => "index_az_bills_on_az_invoice_id"
  add_index "az_bills", ["date_from"], :name => "index_az_bills_on_date_from"
  add_index "az_bills", ["date_till"], :name => "index_az_bills_on_date_till"

  create_table "az_c_images", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "az_c_image_category"
    t.string   "c_image_file_name",    :null => false
    t.string   "c_image_content_type", :null => false
    t.integer  "c_image_file_size",    :null => false
    t.datetime "c_image_updated_at",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "item_type"
    t.integer  "item_id"
  end

  add_index "az_c_images", ["owner_id"], :name => "index_az_c_images_on_owner_id"

  create_table "az_collection_templates", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",   :null => false
  end

  create_table "az_commons", :force => true do |t|
    t.integer  "owner_id",                          :null => false
    t.integer  "az_base_project_id"
    t.string   "name"
    t.text     "description"
    t.string   "comment"
    t.string   "type"
    t.integer  "copy_of"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "seed"
    t.integer  "status",             :default => 0, :null => false
    t.integer  "position",                          :null => false
  end

  add_index "az_commons", ["az_base_project_id"], :name => "index_az_commons_on_az_base_project_id"
  add_index "az_commons", ["owner_id"], :name => "index_az_commons_on_owner_id"

  create_table "az_companies", :force => true do |t|
    t.string   "name",                               :null => false
    t.integer  "ceo_id",                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "updated_from_seeds"
    t.integer  "az_tariff_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "site",               :default => ""
  end

  create_table "az_contacts", :force => true do |t|
    t.integer "my_id",      :null => false
    t.integer "az_user_id", :null => false
  end

  create_table "az_definitions", :force => true do |t|
    t.string   "name"
    t.text     "definition"
    t.integer  "az_user_id"
    t.integer  "az_base_project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",                          :null => false
    t.boolean  "seed"
    t.integer  "copy_of"
    t.integer  "status",             :default => 0, :null => false
    t.integer  "position",                          :null => false
  end

  add_index "az_definitions", ["az_base_project_id"], :name => "index_az_definitions_on_az_base_project_id"
  add_index "az_definitions", ["copy_of"], :name => "index_az_definitions_on_copy_of"
  add_index "az_definitions", ["owner_id"], :name => "index_az_definitions_on_owner_id"

  create_table "az_design_sources", :force => true do |t|
    t.integer  "az_design_id",        :null => false
    t.string   "source_file_name",    :null => false
    t.string   "source_content_type", :null => false
    t.integer  "source_file_size",    :null => false
    t.datetime "source_updated_at",   :null => false
    t.integer  "owner_id",            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "copy_of"
  end

  add_index "az_design_sources", ["az_design_id"], :name => "az_design_id"
  add_index "az_design_sources", ["az_design_id"], :name => "index_az_design_sources_on_az_design_id"
  add_index "az_design_sources", ["copy_of"], :name => "index_az_design_sources_on_copy_of"

  create_table "az_designs", :force => true do |t|
    t.text     "description", :null => false
    t.integer  "az_page_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",    :null => false
    t.integer  "copy_of"
  end

  add_index "az_designs", ["az_page_id"], :name => "index_az_designs_on_az_page_id"

  create_table "az_employees", :force => true do |t|
    t.integer  "az_user_id"
    t.integer  "az_company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",                         :null => false
    t.boolean  "disabled",      :default => false, :null => false
  end

  create_table "az_guest_links", :force => true do |t|
    t.string   "hash_str",           :null => false
    t.integer  "az_base_project_id", :null => false
    t.datetime "expired_at",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",           :null => false
    t.integer  "az_user_id"
    t.string   "url"
  end

  create_table "az_images", :force => true do |t|
    t.integer  "az_design_id",                       :null => false
    t.string   "image_file_name",                    :null => false
    t.string   "image_content_type",                 :null => false
    t.integer  "image_file_size",                    :null => false
    t.datetime "image_updated_at",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",                           :null => false
    t.integer  "copy_of"
    t.integer  "tiny_image_width",   :default => 50, :null => false
    t.integer  "tiny_image_height",  :default => 75, :null => false
  end

  add_index "az_images", ["az_design_id"], :name => "index_az_images_on_az_design_id"
  add_index "az_images", ["copy_of"], :name => "index_az_images_on_copy_of"
  add_index "az_images", ["owner_id"], :name => "index_az_images_on_owner_id"

  create_table "az_invitations", :force => true do |t|
    t.string   "hash_str",        :null => false
    t.string   "email",           :null => false
    t.string   "invitation_type", :null => false
    t.integer  "invitation_data", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "rejected"
  end

  create_table "az_invoices", :force => true do |t|
    t.integer  "az_balance_transaction_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "az_invoices", ["az_balance_transaction_id"], :name => "index_az_invoices_on_az_balance_transaction_id", :unique => true

  create_table "az_languages", :force => true do |t|
    t.string   "name"
    t.string   "english_name"
    t.string   "code"
    t.string   "lang_icon_file_name",    :null => false
    t.string   "lang_icon_content_type", :null => false
    t.integer  "lang_icon_file_size",    :null => false
    t.datetime "lang_icon_updated_at",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_mailing_header_footer", :force => true do |t|
    t.text "header", :null => false
    t.text "footer", :null => false
  end

  create_table "az_mailing_messages", :force => true do |t|
    t.string   "name"
    t.string   "subject"
    t.text     "text"
    t.boolean  "active"
    t.boolean  "force"
    t.datetime "created"
  end

  create_table "az_mailing_messages_categories", :force => true do |t|
    t.integer "az_mailing_message_id"
    t.integer "az_subscribtion_category_id"
  end

  create_table "az_mailings", :force => true do |t|
    t.integer  "az_mailing_message_id",                    :null => false
    t.text     "comment",                                  :null => false
    t.boolean  "active",                :default => false, :null => false
    t.integer  "status",                :default => 1,     :null => false
    t.datetime "created"
  end

  create_table "az_messages", :force => true do |t|
    t.integer  "message_type"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note",                        :null => false
    t.integer  "status1",      :default => 0, :null => false
    t.integer  "status2",      :default => 0, :null => false
    t.integer  "status3",      :default => 0, :null => false
  end

  create_table "az_news", :force => true do |t|
    t.string   "title",                         :null => false
    t.text     "announce",                      :null => false
    t.text     "body",                          :null => false
    t.boolean  "visible",    :default => false, :null => false
    t.integer  "az_user_id",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_operation_times", :force => true do |t|
    t.integer  "az_base_data_type_id", :null => false
    t.integer  "az_operation_id",      :null => false
    t.float    "operation_time"
    t.integer  "copy_of"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",             :null => false
    t.boolean  "seed"
  end

  create_table "az_operations", :force => true do |t|
    t.string   "name",                                                                   :null => false
    t.string   "crud_name",                                                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "complexity", :limit => 10, :precision => 10, :scale => 0, :default => 1, :null => false
    t.integer  "float",      :limit => 10, :precision => 10, :scale => 0, :default => 1, :null => false
  end

  create_table "az_outboxes", :force => true do |t|
    t.integer  "mailing_id"
    t.integer  "az_user_id"
    t.boolean  "status",     :default => false, :null => false
    t.text     "e_message",                     :null => false
    t.datetime "created"
  end

  create_table "az_page_az_page_types", :force => true do |t|
    t.integer  "az_page"
    t.integer  "az_page_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",     :null => false
  end

  create_table "az_page_az_pages", :force => true do |t|
    t.integer  "parent_page_id"
    t.integer  "page_id"
    t.integer  "position",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "az_page_az_pages", ["page_id"], :name => "index_az_page_az_pages_on_page_id"
  add_index "az_page_az_pages", ["parent_page_id"], :name => "index_az_page_az_pages_on_parent_page_id"

  create_table "az_page_az_project_blocks", :force => true do |t|
    t.integer  "az_page_id",         :null => false
    t.integer  "az_base_project_id", :null => false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_pages", :force => true do |t|
    t.string   "name",                                                                          :null => false
    t.integer  "az_base_project_id",                                                            :null => false
    t.integer  "position",                                                                      :null => false
    t.integer  "parent_id"
    t.decimal  "estimated_time",                  :precision => 8, :scale => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "az_design_double_page_id"
    t.integer  "az_functionality_double_page_id"
    t.integer  "copy_of"
    t.integer  "page_type",                                                     :default => 0
    t.text     "description"
    t.string   "title",                                                         :default => ""
    t.integer  "owner_id",                                                                      :null => false
    t.integer  "status",                                                        :default => 0,  :null => false
    t.integer  "tr_position"
    t.boolean  "embedded"
    t.boolean  "root"
  end

  add_index "az_pages", ["az_base_project_id"], :name => "index_az_pages_on_az_base_project_id"
  add_index "az_pages", ["az_design_double_page_id"], :name => "index_az_pages_on_az_design_double_page_id"
  add_index "az_pages", ["az_functionality_double_page_id"], :name => "index_az_pages_on_az_functionality_double_page_id"
  add_index "az_pages", ["parent_id"], :name => "index_az_pages_on_parent_id"

  create_table "az_participants", :force => true do |t|
    t.integer  "az_project_id"
    t.integer  "az_rm_role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",       :null => false
    t.integer  "az_employee_id", :null => false
  end

  add_index "az_participants", ["az_employee_id"], :name => "index_az_participants_on_az_employee_id"
  add_index "az_participants", ["az_project_id"], :name => "index_az_participants_on_az_project_id"
  add_index "az_participants", ["owner_id"], :name => "index_az_participants_on_owner_id"

  create_table "az_payment_responses", :force => true do |t|
    t.integer  "az_payment_id"
    t.string   "status"
    t.text     "response"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "az_payment_responses", ["az_payment_id"], :name => "index_az_payment_responses_on_az_payment_id"
  add_index "az_payment_responses", ["transaction_id"], :name => "index_az_payment_responses_on_transaction_id"

  create_table "az_payments", :force => true do |t|
    t.integer  "az_company_id"
    t.decimal  "amount",        :precision => 20, :scale => 2,                    :null => false
    t.boolean  "started",                                      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment",                                      :default => ""
  end

  add_index "az_payments", ["az_company_id"], :name => "index_az_payments_on_az_company_id"

  create_table "az_project_definitions", :force => true do |t|
    t.integer  "az_base_project_id"
    t.integer  "az_definition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",           :null => false
  end

  create_table "az_project_stat_updates", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_project_statuses", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "owner_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",       :default => 0, :null => false
    t.text     "description",                :null => false
  end

  create_table "az_purchases", :force => true do |t|
    t.integer  "az_company_id",    :null => false
    t.integer  "az_store_item_id", :null => false
    t.integer  "az_bill_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "az_purchases", ["az_bill_id"], :name => "index_az_purchases_on_az_bill_id"
  add_index "az_purchases", ["az_company_id"], :name => "index_az_purchases_on_az_company_id"
  add_index "az_purchases", ["az_store_item_id"], :name => "index_az_purchases_on_az_store_item_id"

  create_table "az_register_confirmations", :force => true do |t|
    t.integer  "az_user_id"
    t.string   "confirm_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_reset_passwords", :force => true do |t|
    t.string   "hash_str",   :null => false
    t.integer  "az_user_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_rm_roles", :force => true do |t|
    t.integer  "rm_role_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_scetch_programs", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.string   "sp_icon_file_name",    :null => false
    t.string   "sp_icon_content_type", :null => false
    t.integer  "sp_icon_file_size",    :null => false
    t.datetime "sp_icon_updated_at",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_store_item_scetches", :force => true do |t|
    t.string   "scetch_file_name",    :null => false
    t.string   "scetch_content_type", :null => false
    t.integer  "scetch_file_size",    :null => false
    t.datetime "scetch_updated_at",   :null => false
    t.integer  "az_store_item_id"
    t.string   "alt",                 :null => false
    t.string   "title",               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "az_store_item_scetches", ["az_store_item_id"], :name => "index_az_store_item_scetches_on_az_store_item_id"

  create_table "az_store_items", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.float    "price"
    t.boolean  "visible"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",          :null => false
    t.text     "announce",             :null => false
    t.text     "manual",               :null => false
    t.integer  "az_language_id"
    t.integer  "az_scetch_program_id"
    t.string   "scheme_file_name"
    t.string   "scheme_content_type"
    t.integer  "scheme_file_size"
    t.datetime "scheme_updated_at"
  end

  create_table "az_subscribtion_categories", :force => true do |t|
    t.string   "name"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_subscribtions", :force => true do |t|
    t.integer  "az_user_id"
    t.integer  "az_subscribtion_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_tariffs", :force => true do |t|
    t.string   "name"
    t.decimal  "price",                  :precision => 9, :scale => 2, :default => 100.0, :null => false
    t.integer  "quota_disk",                                           :default => 0,     :null => false
    t.integer  "quota_active_projects",                                :default => 0,     :null => false
    t.integer  "quota_employees",                                      :default => 0,     :null => false
    t.integer  "position",                                                                :null => false
    t.integer  "tariff_type",                                                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "optimal"
    t.boolean  "show_logo_and_site"
    t.integer  "quota_public_projects",                                :default => 0
    t.integer  "quota_private_projects",                               :default => 0
  end

  create_table "az_tasks", :force => true do |t|
    t.string   "name",                                                             :null => false
    t.string   "description",                                                      :null => false
    t.decimal  "estimated_time", :precision => 24, :scale => 2
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "task_type",                                     :default => 0,     :null => false
    t.integer  "az_rm_role_id"
    t.boolean  "role_user",                                     :default => false, :null => false
    t.boolean  "role_admin",                                    :default => false, :null => false
    t.integer  "owner_id",                                                         :null => false
    t.boolean  "seed"
    t.integer  "copy_of"
    t.boolean  "role_common",                                   :default => false, :null => false
    t.integer  "position",                                                         :null => false
  end

  create_table "az_tr_texts", :force => true do |t|
    t.string   "name",                               :null => false
    t.integer  "owner_id",                           :null => false
    t.integer  "az_operation_id"
    t.integer  "data_type"
    t.text     "text"
    t.integer  "copy_of"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "seed",            :default => false, :null => false
  end

  add_index "az_tr_texts", ["owner_id"], :name => "index_az_tr_texts_on_owner_id"

  create_table "az_typed_pages", :force => true do |t|
    t.integer  "az_page_id"
    t.integer  "az_base_data_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id",             :null => false
    t.integer  "copy_of"
  end

  add_index "az_typed_pages", ["az_base_data_type_id"], :name => "index_az_typed_pages_on_az_base_data_type_id"
  add_index "az_typed_pages", ["az_page_id"], :name => "index_az_typed_pages_on_az_page_id"
  add_index "az_typed_pages", ["copy_of"], :name => "index_az_typed_pages_on_copy_of"
  add_index "az_typed_pages", ["owner_id"], :name => "index_az_typed_pages_on_owner_id"

  create_table "az_user_logins", :force => true do |t|
    t.integer  "az_user_id"
    t.string   "ip"
    t.string   "browser"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "az_users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "lastname",                  :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.text     "roles"
    t.boolean  "disabled",                                 :default => true
    t.integer  "azalo_invitation_count",                   :default => 0
    t.integer  "company_invitation_count",                 :default => 0
    t.boolean  "never_visited",                            :default => true, :null => false
    t.text     "note",                                                       :null => false
    t.boolean  "la_accepted"
  end

  add_index "az_users", ["login"], :name => "index_az_users_on_login", :unique => true

  create_table "az_using_periods", :force => true do |t|
    t.integer  "az_company_id",                :null => false
    t.string   "type"
    t.datetime "ends_at",                      :null => false
    t.integer  "state",         :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "az_using_periods", ["az_company_id", "type"], :name => "index_az_using_periods_on_az_company_id_and_type"
  add_index "az_using_periods", ["az_company_id"], :name => "index_az_using_periods_on_az_company_id"
  add_index "az_using_periods", ["ends_at"], :name => "index_az_using_periods_on_ends_at"

  create_table "az_validators", :force => true do |t|
    t.integer  "owner_id",       :null => false
    t.integer  "az_variable_id"
    t.string   "name",           :null => false
    t.text     "description",    :null => false
    t.text     "condition"
    t.text     "message",        :null => false
    t.integer  "position"
    t.integer  "copy_of"
    t.boolean  "seed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "az_validators", ["az_variable_id"], :name => "index_az_validators_on_az_variable_id"
  add_index "az_validators", ["owner_id"], :name => "index_az_validators_on_owner_id"
  add_index "az_validators", ["owner_id"], :name => "owner_id"

  create_table "az_variables", :force => true do |t|
    t.string   "name"
    t.integer  "az_base_data_type_id"
    t.integer  "az_struct_data_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "copy_of"
    t.integer  "owner_id",               :null => false
    t.integer  "position"
    t.text     "description"
  end

  add_index "az_variables", ["az_base_data_type_id"], :name => "az_base_data_type_id"
  add_index "az_variables", ["az_base_data_type_id"], :name => "index_az_variables_on_az_base_data_type_id"
  add_index "az_variables", ["az_struct_data_type_id"], :name => "index_az_variables_on_az_struct_data_type_id"
  add_index "az_variables", ["copy_of"], :name => "index_az_variables_on_copy_of"
  add_index "az_variables", ["owner_id"], :name => "index_az_variables_on_owner_id"

end
