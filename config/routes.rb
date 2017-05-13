Azalo::Application.routes.draw do

  resources :az_project_stat_updates
  resources :az_base_project_stats
  resources :az_articles
  resources :az_warning_periods
  resources :az_subscribtions
  resources :az_test_periods
  resources :az_purchases
  resources :az_store_item_scetches
  resources :az_scetch_programs
  resources :az_languages
  resources :az_c_images
  resources :az_invoices
  resources :az_bills
  resources :az_balance_transactions
  resources :az_stores
  resources :az_tr_texts
  resources :az_user_logins
  resources :az_design_sources
  resources :az_tariff_limit_types
  resources :az_tariffs
  resources :az_messages
  resources :az_page_az_project_blocks
  resources :az_validators
  resources :az_guest_links
  resources :az_news
  resources :az_project_statuses
  resources :az_commons
  resources :az_commons_commons
  resources :az_commons_purpose_exploitations
  resources :az_commons_purpose_functionals
  resources :az_commons_requirements_hostings
  resources :az_commons_requirements_reliabilities
  resources :az_commons_acceptance_conditions
  resources :az_commons_content_creations
  resources :az_commons_functionalities
  resources :az_invitations
  resources :az_base_projects_az_definitions
  resources :az_base_projects
  resources :az_definitions
  resources :az_register_confirmations
  resources :az_participants
  resources :az_employees
  match 'result_lp' => 'az_payments#result_lp', :as => :liqpay_result
  match 'show_payment_result_lp' => 'az_payments#show_payment_result_lp', :as => :liqpay_show_payment_result
  match 'az_companies/index_ceo_note' => 'az_companies#index_ceo_note', :as => :index_ceo_note
  match 'az_companies/update_company/:id' => 'az_companies#user_update', :as => :user_update_company
  match 'az_payments/make_payment/:company_id/' => 'az_payments#make', :as => :make_payment
  match 'az_payments/status' => 'az_payments#status', :as => :payment_status
  match 'az_payments/success' => 'az_payments#success', :as => :payment_success
  match 'az_payments/fail' => 'az_payments#fail', :as => :payment_fail
  match 'az_companies/pay/:id' => 'az_companies#pay', :as => :pay
  match 'az_companies/billing_history/:id' => 'az_companies#billing_history', :as => :billing_history
  match 'az_companies/change_tariff/:id' => 'az_companies#change_tariff', :as => :change_tariff
  match 'az_companies/set_tariff/:id' => 'az_companies#set_tariff', :as => :set_tariff
  match 'store_items/:id' => 'az_store_items#show', :as => :store_items
  match 'articles' => 'az_articles#index_public', :as => :articles
  match 'articles/:id' => 'az_articles#show', :as => :article
  resources :az_companies
  resources :az_store_items
  resources :az_allowed_operations
  resources :az_typed_page_operations
  resources :az_operation_times
  resources :az_operations
  resources :az_profiles
  resources :az_page_az_tasks
  resources :az_project_blocks
  resources :az_rm_roles
  resources :az_tasks
  resources :az_collection_templates
  resources :az_variables
  resources :az_struct_data_types
  resources :az_enum_data_types
  resources :az_collection_data_types
  resources :az_simple_data_types
  resources :az_base_data_types
  resources :az_page_az_page_types
  resources :az_page_types
  resources :az_images
  resources :az_pages_types
  resources :az_typed_pages
  match '/az_settings/configuration' => 'az_settings#configuration', :as => :configuration
  resources :az_settings
  resources :az_user_settings
  resources :az_services
  resources :az_dashboard
  resources :az_designs
  resources :az_projects do
    collection do
      get :show_design
    end


  end

  resources :az_projects
  resources :az_project_snippets
  resources :az_pages
  resources :az_contacts
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/login' => 'sessions#new', :as => :login
  match '/register' => 'az_users#create', :as => :register
  match '/signup' => 'az_users#new', :as => :signup
  match '/accept_la' => 'az_users#accept_la', :as => :accept_la
  match '/accept_la/:choise' => 'az_users#accept_la', :as => :accept_la
  match '/license_agreement.html' => 'az_users#license_agreement', :as => :license_agreement
  match '/new_employee/:hash_str' => 'az_users#new_employee', :as => :new_employee
  match '/registered' => 'az_users#registered', :as => :registered
  match '/confirmed' => 'az_users#confirmed', :as => :confirmed
  match '/not_confirmed' => 'az_users#not_confirmed', :as => :not_confirmed
  match '/change_password' => 'az_users#change_password', :as => :not_confirmed
  match '/az_users/change_subscribtion' => 'az_users#change_subscribtion', :as => :change_subscribtion
  match '/unsubscribe/:id' => 'az_users#unsubscribe', :as => :unsubscribe
  match '/dashboard' => 'az_dashboard#index', :as => :dashboard
  match '/new_main' => 'az_dashboard#new_index', :as => :new_dashboard
  match '/video/:id' => 'az_dashboard#video', :as => :video
  match '/explore' => 'az_dashboard#explore', :as => :explore
  match '/explore/all' => 'az_dashboard#explore_all', :as => :explore_all
  match '/explore/active' => 'az_dashboard#explore_active', :as => :explore_active
  match '/explore/noteworthy' => 'az_dashboard#explore_noteworthy', :as => :explore_noteworthy
  match '/store' => 'az_store#store', :as => :store
  match '/store/rss' => 'az_store#rss', :as => :store_rss
  match '/update_password' => 'az_users#update_password', :as => :update_password
  match '/recover_password' => 'az_users#recover_password', :as => :recover_password
  match '/news/:id' => 'az_news#show', :as => :invite_to_site
  match '/old_tariffs' => 'az_dashboard#tariff_test', :as => :dashboard_tariffs
  match '/tariffs' => 'az_dashboard#tariffs', :as => :dashboard_new_tariffs
  match '/news_archive/:year/:month' => 'az_news#archive', :as => :dashboard_news_archive
  match '/feedback' => 'az_messages#new', :as => :feedback
  match '/invite_to_site/:user_id' => 'az_invitations#invite_to_site', :as => :invite_to_site
  match '/invite_to_company/:owner_id' => 'az_invitations#invite_to_company', :as => :invite_to_company
  match '/confirm_registration/:hash_str' => 'az_users#confirm_registration', :as => :confirm_registration
  match '/new_password/:hash_str' => 'az_users#new_password', :as => :new_password
  match '/set_new_password' => 'az_users#set_new_password', :as => :set_new_password, :via => :put
  match '/az_users/users_projects_pages' => 'az_users#users_projects_pages', :as => :users_projects_pages
  resources :az_users
  resource :session
  match 'az_pages/:az_page_id/new_sub_page' => 'az_pages#new_sub_page', :as => :new_sub_page
  match 'az_pages/add_data_type/:id/:data_type_id' => 'az_pages#add_data_type', :as => :add_data_type
  match 'az_pages/remove_data_type/:id/:data_type_id' => 'az_pages#remove_data_type', :as => :remove_data_type
  match 'az_pages/new/:project_id' => 'az_pages#new', :as => :create_page
  match 'az_pages/destroy_bp/:id' => 'az_pages#destroy_bp', :as => :destroy_bp
  match 'az_pages/destroy_lnk/:id/:parent_page_id' => 'az_pages#destroy_lnk', :as => :destroy_lnk
  match 'az_pages/:id/edit_page' => 'az_pages#edit_page', :as => :edit_page
  match 'az_projects/change_members/:id' => 'az_projects#change_members', :as => :change_members
  match 'az_projects/show/:id/:show_type' => 'az_projects#show', :as => :show_project
  match 'az_projects/add_common/:id/:common_id' => 'az_projects#add_common', :as => :add_common
  match 'az_projects/remove_common/:id/:common_id' => 'az_projects#remove_common', :as => :remove_common
  match 'az_base_projects/add_common_a/:id/:common_id' => 'az_base_projects#add_common_a', :as => :add_common_a
  match 'az_base_projects/remove_common_a/:id/:common_id' => 'az_base_projects#remove_common_a', :as => :remove_common_a
  match 'az_projects/add_definition/:id/:definition_id' => 'az_projects#add_definition', :as => :add_definition
  match 'az_projects/remove_definition/:id/:definition_id' => 'az_projects#remove_definition', :as => :remove_definition
  match 'az_base_projects/add_definition_a/:id/:definition_id' => 'az_base_projects#add_definition_a', :as => :add_definition_a
  match 'az_base_projects/remove_definition_a/:id/:definition_id' => 'az_base_projects#remove_definition_a', :as => :remove_definition_a
  match 'az_base_projects/move_definition_up_tr/:id/:definition_id' => 'az_base_projects#move_definition_up_tr', :as => :move_definition_up_tr
  match 'az_base_projects/move_definition_down_tr/:id/:definition_id' => 'az_base_projects#move_definition_down_tr', :as => :move_definition_down_tr
  match 'az_base_projects/move_common_up_tr/:id/:common_id' => 'az_base_projects#move_common_up_tr', :as => :move_common_up_tr
  match 'az_base_projects/move_common_down_tr/:id/:common_id' => 'az_base_projects#move_common_down_tr', :as => :move_common_down_tr
  match 'az_base_projects/tr_commons_content/:id/:common_class' => 'az_base_projects#tr_commons_content', :as => :tr_commons_content
  match 'az_projects/tr_sort_public_pages/:id' => 'az_projects#tr_sort_public_pages', :as => :tr_sort_public_pages
  match 'az_projects/tr_sort_admin_pages/:id' => 'az_projects#tr_sort_admin_pages', :as => :tr_sort_admin_pages
  match 'az_projects/tr_collapse_admin_pages/:id' => 'az_projects#tr_collapse_admin_pages', :as => :tr_collapse_admin_pages
  match 'az_projects/tr_expand_admin_pages/:id' => 'az_projects#tr_expand_admin_pages', :as => :tr_expand_admin_pages
  match 'az_projects/tr_collapse_public_pages/:id' => 'az_projects#tr_collapse_public_pages', :as => :tr_collapse_public_pages
  match 'az_projects/tr_expand_public_pages/:id' => 'az_projects#tr_expand_public_pages', :as => :tr_expand_public_pages
  match 'az_projects/test_pages_list/:id' => 'az_projects#test_pages_list', :as => :test_pages_list
  match 'az_project_blocks/show/:id/:show_type' => 'az_project_blocks#show', :as => :show_project_block
  match 'az_project_blocks/add_definition/:id/:definition_id' => 'az_projects#add_definition', :as => :add_definition
  match 'az_project_blocks/remove_definition/:id/:definition_id' => 'az_projects#remove_definition', :as => :remove_definition
  match 'az_projects/new/:owner_id' => 'az_projects#new', :as => :new
  match 'az_struct_data_types/new/:owner_id' => 'az_struct_data_types#new', :as => :new
  match 'az_struct_data_types/new/:owner_id/:az_base_project_id' => 'az_struct_data_types#new', :as => :new
  match 'az_struct_data_types/copy_and_attach_to_project/:id/:project_id' => 'az_struct_data_types#copy_and_attach_to_project', :as => :copy_and_attach_to_project
  match 'az_struct_data_types/copy_to_stock/:id' => 'az_struct_data_types#copy_to_stock', :as => :copy_struct_to_stock
  match 'az_definitions/new/:owner_id' => 'az_definitions#new', :as => :new
  match 'az_definitions/new/:owner_id/:az_base_project_id' => 'az_definitions#new', :as => :new
  match 'az_definitions/tr_new_definition_dialog/:owner_id/:az_base_project_id' => 'az_definitions#tr_new_definition_dialog', :as => :tr_new_definition_dialog
  match 'az_definitions/create_definition/:owner_id' => 'az_definitions#create_definition', :as => :create_definition
  match 'az_validators/new/:owner_id' => 'az_validators#new', :as => :new
  match 'az_validators/new/:owner_id/:az_variable_id' => 'az_validators#new', :as => :new
  match 'az_variables/move_up/:id' => 'az_variables#move_up', :as => :move_up_az_page
  match 'az_variables/move_down/:id' => 'az_variables#move_down', :as => :move_down_az_page
  match 'az_variables/new/:az_struct_data_type_id' => 'az_variables#new', :as => :new
  match 'az_collection_data_types/new/:az_base_data_type_id' => 'az_collection_data_types#new', :as => :new
  match 'az_tasks/new/:owner_id' => 'az_tasks#new', :as => :new
  match 'az_tr_texts/new/:owner_id' => 'az_tr_texts#new', :as => :new_tr_text
  match 'az_project_blocks/new/:owner_id' => 'az_project_blocks#new', :as => :new
  match 'az_project_blocks/copy/:id/:owner_id' => 'az_project_blocks#copy', :as => :copy
  match 'az_project_blocks/fork/:id/:owner_id' => 'az_project_blocks#fork', :as => :fork_block
  match 'az_projects/copy/:id/:owner_id' => 'az_projects#copy', :as => :copy
  match 'az_projects/fork/:id/:owner_id' => 'az_projects#fork', :as => :fork_project
  match 'az_projects/real_fork/:id/:owner_id' => 'az_projects#real_fork', :as => :real_fork_project
  match 'commons/new/:owner_id' => 'az_commons_commons#new', :as => :new_common
  match 'purpose_exploitations/new/:owner_id' => 'az_commons_purpose_exploitations#new', :as => :new_purpose_expl
  match 'purpose_functional/new/:owner_id' => 'az_commons_purpose_functionals#new', :as => :new_purpose_func
  match 'requirements_hosting/new/:owner_id' => 'az_commons_requirements_hostings#new', :as => :new_requirements_hosting
  match 'requirements_reliability/new/:owner_id' => 'az_commons_requirements_reliabilities#new', :as => :new_requirements_reliability
  match 'acceptance_conditions/new/:owner_id' => 'az_commons_acceptance_conditions#new', :as => :new_acceptance_conditions
  match 'content_creation/new/:owner_id' => 'az_commons_content_creations#new', :as => :new_content_creation
  match 'commons/new/:owner_id/:az_base_project_id' => 'az_commons_commons#new', :as => :new_common
  match 'purpose_exploitations/new/:owner_id/:az_base_project_id' => 'az_commons_purpose_exploitations#new', :as => :new_purpose_expl
  match 'purpose_functional/new/:owner_id/:az_base_project_id' => 'az_commons_purpose_functionals#new', :as => :new_purpose_func
  match 'requirements_hosting/new/:owner_id/:az_base_project_id' => 'az_commons_requirements_hostings#new', :as => :new_requirements_hosting
  match 'requirements_reliability/new/:owner_id/:az_base_project_id' => 'az_commons_requirements_reliabilities#new', :as => :new_requirements_reliability
  match 'acceptance_conditions/new/:owner_id/:az_base_project_id' => 'az_commons_acceptance_conditions#new', :as => :new_acceptance_conditions
  match 'content_creation/new/:owner_id/:az_base_project_id' => 'az_commons_content_creations#new', :as => :new_content_creation
  match 'az_commons_commons/tr_new_dialog/:owner_id/:az_base_project_id' => 'az_commons_commons#tr_new_dialog', :as => :tr_new_purpose_comm
  match 'az_commons_purpose_exploitations/tr_new_dialog/:owner_id/:az_base_project_id' => 'az_commons_purpose_exploitations#tr_new_dialog', :as => :tr_new_purpose_expl
  match 'az_commons_purpose_functionals/tr_new_dialog/:owner_id/:az_base_project_id' => 'az_commons_purpose_functionals#tr_new_dialog', :as => :tr_new_purpose_func
  match 'az_commons_functionalities/tr_new_dialog/:owner_id/:az_base_project_id' => 'az_commons_functionalities#tr_new_dialog', :as => :tr_new_functionalities
  match 'az_commons_content_creations/tr_new_dialog/:owner_id/:az_base_project_id' => 'az_commons_content_creations#tr_new_dialog', :as => :tr_new_purpose_expl
  match 'az_commons_requirements_hostings/tr_new_dialog/:owner_id/:az_base_project_id' => 'az_commons_requirements_hostings#tr_new_dialog', :as => :tr_new_purpose_expl
  match 'az_commons_requirements_reliabilities/tr_new_dialog/:owner_id/:az_base_project_id' => 'az_commons_requirements_reliabilities#tr_new_dialog', :as => :tr_new_purpose_expl
  match 'az_commons_acceptance_conditions/tr_new_dialog/:owner_id/:az_base_project_id' => 'az_commons_acceptance_conditions#tr_new_dialog', :as => :tr_new_purpose_expl
  match 'az_struct_data_types/move_up/:id' => 'az_struct_data_types#move_up', :as => :struct_move_up
  match 'az_struct_data_types/move_down/:id' => 'az_struct_data_types#move_down', :as => :struct_move_down
  match 'az_struct_data_types/move_up_tr/:id' => 'az_struct_data_types#move_up_tr', :as => :struct_move_up_tr
  match 'az_struct_data_types/move_down_tr/:id' => 'az_struct_data_types#move_down_tr', :as => :struct_move_down_tr
  match 'az_projects/guest_show/:hash_str' => 'az_projects#guest_show', :as => :guest_show
  match 'az_projects/show_tr/:id' => 'az_projects#show_tr', :as => :show_tr
  match 'az_projects/show_tr/:id' => 'az_projects#show_tr', :as => :show_tr
  match 'az_projects/show_sub_tree/:id/:parent_page_id/:page_id/:show_type' => 'az_projects#show_sub_tree', :as => :show_sub_tree1
  match 'az_project_blocks/show_sub_tree/:id/:parent_page_id/:page_id/:show_type' => 'az_project_blocks#show_sub_tree', :as => :show_sub_tree2
  match 'az_projects/show_sub_tree2/:id/:page_id/:show_type' => 'az_projects#show_sub_tree2', :as => :show_sub_tree21
  match 'az_project_blocks/show_sub_tree2/:id/:page_id/:show_type' => 'az_project_blocks#show_sub_tree2', :as => :show_sub_tree22
  match 'az_projects/show_pure_tr/:id' => 'az_projects#show_pure_tr', :as => :show_pure_tr
  match 'az_projects/show_pure_tr_md/:id' => 'az_projects#show_pure_tr_md', :as => :show_pure_tr_md
  match 'az_projects/add_component/:id/:az_project_block_id' => 'az_projects#add_component', :as => :add_component
  match 'az_projects/remove_component/:id/:az_project_block_id' => 'az_projects#remove_component', :as => :remove_component
  match 'az_projects/data_box/:id' => 'az_projects#data_box', :as => :data_box
  match 'az_designs/update_design/:id' => 'az_designs#update_design', :as => :update_design
  match 'az_designs/new_design/:id' => 'az_designs#new_design', :as => :new_design
  match 'az_designs/add_source/:id/:design_rnd' => 'az_designs#add_source', :as => :add_source
  match 'az_designs/create_source/:id' => 'az_designs#create_source', :as => :create_source
  match 'az_pages/designs_tooltip/:id' => 'az_pages#designs_tooltip', :as => :designs_tooltip
  match 'az_pages/design/:id' => 'az_pages#new_design', :as => :create_design
  match 'az_pages/page_box/:id/:show_mode' => 'az_pages#page_box', :as => :page_box_with_mode
  match 'az_pages/page_box/:id' => 'az_pages#page_box', :as => :page_box
  match 'az_pages/page_box3/:id/:link_id/:show_mode' => 'az_pages#page_box3', :as => :page_box3
  match 'az_pages/add_page_parent/:id/:parent_id' => 'az_pages#add_page_parent', :as => :add_page_parent
  match 'az_pages/change_page_parent/:id/:link_id/:new_parent_id' => 'az_pages#change_page_parent', :as => :change_page_parent
  match 'az_pages/set_functionality_source/:id/:source_id' => 'az_pages#set_functionality_source', :as => :attach_page_to_page
  match 'az_pages/set_functionality_source/:id' => 'az_pages#set_functionality_source', :as => :attach_page_to_page
  match 'az_pages/set_design_source/:id/:source_id' => 'az_pages#set_design_source', :as => :attach_page_to_page
  match 'az_pages/set_design_source/:id' => 'az_pages#set_design_source', :as => :attach_page_to_page
  match 'az_pages/get_page_description1/:id/:tr_text_id/:data_type_id' => 'az_pages#get_page_description1', :as => :get_description1
  match 'az_images/:design_rnd' => 'az_images#create', :as => :create_image
  match 'az_images/destroy_by_rnd/:rnd' => 'az_images#destroy_by_rnd', :as => :destroy_image_by_rnd
  match 'az_design_sources/destroy_by_rnd/:rnd' => 'az_design_sources#destroy_by_rnd', :as => :destroy_source_by_rnd
  match 'az_project_blocks/summary/:id' => 'az_project_blocks#summary', :as => :summary
  match 'az_projects/show_task_list/:id' => 'az_projects#show_task_list', :as => :show_task_list
  match 'az_pages/move_up/:id/:parent_page_id' => 'az_pages#move_up', :as => :move_up_az_page
  match 'az_pages/move_down/:id/:parent_page_id' => 'az_pages#move_down', :as => :move_down_az_page
  match 'az_pages/move_tr_up/:id/:positions' => 'az_pages#move_tr_up', :as => :move_tr_up_az_page
  match 'az_pages/move_tr_down/:id/:positions' => 'az_pages#move_tr_down', :as => :move_tr_down_az_page
  match 'az_pages/attach_component_page/:id/:component_page_id' => 'az_pages#attach_component_page', :as => :attach_component_page
  match 'az_pages/remove_component_page/:id/:component_page_id' => 'az_pages#remove_component_page', :as => :remove_component_page
  match 'az_pages/description_wo_title_dialog/:id/:update_page_id' => 'az_pages#description_wo_title_dialog', :as => :description_wo_title_dialog
  match 'az_pages/tr_description_wo_title_tooltip/:id/:update_page_id' => 'az_pages#tr_description_wo_title_tooltip', :as => :tr_description_wo_title_tooltip
  match 'az_pages/tr_description_tooltip/:id' => 'az_pages#tr_description_tooltip', :as => :tr_description_tooltip
  match 'az_pages/tr_page_status_dialog/:id/:project_id' => 'az_pages#tr_page_status_dialog', :as => :tr_page_status_dialog
  match 'az_collection_data_type/copy/:id' => 'az_collection_data_types#copy', :as => :copy_az_collection_data_type
  match 'az_variable/copy/:id' => 'az_variables#copy', :as => :copy_az_variable
  match 'az_struct_data_type/copy/:id' => 'az_struct_data_types#copy', :as => :copy_az_struct_data_type
  match 'structs' => 'az_struct_data_types#index_user', :as => :structs
  match 'settings' => 'az_user_settings#index', :as => :settings
  match 'seeds' => 'az_settings#seeds', :as => :seeds
  match 'projects' => 'az_projects#index_user', :as => :projects
  match 'definitions' => 'az_definitions#index_user', :as => :definitions
  match 'profile' => 'az_profiles#index', :as => :profile
  match 'employees' => 'az_employees#index_user', :as => :employees
  match 'components' => 'az_project_blocks#index_user', :as => :components
  match 'tasks' => 'az_tasks#index_user', :as => :tasks
  match 'tr_texts' => 'az_tr_texts#index_user', :as => :tr_texts
  match 'contacts' => 'az_contacts#index_user', :as => :contacts
  match 'validators' => 'az_validators#index_user', :as => :validators
  match 'commons' => 'az_commons_commons#index_user', :as => :commons
  match 'purpose_exploitations' => 'az_commons_purpose_exploitations#index_user', :as => :purpose_expl
  match 'purpose_functionals' => 'az_commons_purpose_functionals#index_user', :as => :purpose_func
  match 'functionality' => 'az_commons_functionalities#index_user', :as => :functionality
  match 'requirements_hosting' => 'az_commons_requirements_hostings#index_user', :as => :requirements_hosting
  match 'requirements_reliability' => 'az_commons_requirements_reliabilities#index_user', :as => :requirements_reliability
  match 'acceptance_conditions' => 'az_commons_acceptance_conditions#index_user', :as => :acceptance_conditions
  match 'content_creation' => 'az_commons_content_creations#index_user', :as => :content_creation
  match 'enums' => 'az_enums#index_user', :as => :enums
  match 'guest_links' => 'az_guest_links/:project_id#index_project', :as => :guest_links
  match 'guest_links/new/:id' => 'az_guest_links/:project_id#new', :as => :new_guest_links
  match 'az_typed_pages/operations_dialog/:id' => 'az_typed_pages#operations_dialog', :as => :new_guest_links
  match 'az_typed_pages/update_operations/:id' => 'az_typed_pages#update_operations', :as => :update_operations
  match 'az_store_items/buy/:id/:company_id' => 'az_store_items#buy', :as => :buy
  match 'az_activities/active_companies' => 'az_activities#active_companies'
  match 'az_activities/active_projects' => 'az_activities#active_projects'
  match '/:controller(/:action(/:id))'
  match '/' => 'az_dashboard#index', :as => :index

end