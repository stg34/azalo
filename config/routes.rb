ActionController::Routing::Routes.draw do |map|
  map.resources :az_project_stat_updates

  map.resources :az_base_project_stats

  map.resources :az_articles
  map.resources :az_warning_periods
  map.resources :az_subscribtions
  map.resources :az_test_periods
  map.resources :az_purchases
  map.resources :az_store_item_scetches
  map.resources :az_scetch_programs
  map.resources :az_languages
  map.resources :az_c_images
  map.resources :az_invoices
  map.resources :az_bills
  #map.resources :az_payments
  map.resources :az_balance_transactions
  map.resources :az_stores
  map.resources :az_tr_texts
  map.resources :az_user_logins
  map.resources :az_design_sources
  map.resources :az_tariff_limit_types
  map.resources :az_tariffs
  map.resources :az_messages
  map.resources :az_page_az_project_blocks
  map.resources :az_validators
  map.resources :az_guest_links
  map.resources :az_news
  map.resources :az_project_statuses
  map.resources :az_commons
  map.resources :az_commons_commons
  map.resources :az_commons_purpose_exploitations
  map.resources :az_commons_purpose_functionals
  map.resources :az_commons_requirements_hostings
  map.resources :az_commons_requirements_reliabilities
  map.resources :az_commons_acceptance_conditions
  map.resources :az_commons_content_creations
  map.resources :az_commons_functionalities
  map.resources :az_invitations
  map.resources :az_base_projects_az_definitions
  map.resources :az_base_projects
  map.resources :az_definitions
  map.resources :az_register_confirmations
  map.resources :az_participants
  map.resources :az_employees

  map.liqpay_result            'result_lp',                   :controller => 'az_payments', :action => 'result_lp'
  map.liqpay_show_payment_result  'show_payment_result_lp',   :controller => 'az_payments', :action => 'show_payment_result_lp'

  map.index_ceo_note           'az_companies/index_ceo_note', :controller => 'az_companies', :action => 'index_ceo_note'
  map.user_update_company      'az_companies/update_company/:id', :controller => 'az_companies', :action => 'user_update'
  #map.make_payment2             'az_payments/make_payment2/:company_id/:amount', :controller => 'az_payments', :action => 'new'
  #map.make_payment             'az_payments/make_payment/:company_id/', :controller => 'az_payments', :action => 'make'
  #map.waiting_payments         'az_companies/waiting_payments/:id', :controller => 'az_companies', :action => 'waiting_payments'

  #match 'intercassa/status'       => 'payments#status',  :payment_system => :intercassa, :via => [:get, :post]
  #match 'intercassa/success'      => 'payments#success', :payment_system => :intercassa, :via => [:get, :post]
  #match 'intercassa/fail'         => 'payments#fail',    :payment_system => :intercassa, :via => [:get, :post]
  #match 'intercassa/make/payment' => 'payments#make',    :payment_system => :intercassa, :via => [:get, :post]

  map.make_payment    'az_payments/make_payment/:company_id/',  :controller => 'az_payments', :action => 'make'
  map.payment_status  'az_payments/status',                     :controller => 'az_payments', :action => 'status'
  map.payment_success 'az_payments/success',                    :controller => 'az_payments', :action => 'success'    
  map.payment_fail    'az_payments/fail',                       :controller => 'az_payments', :action => 'fail'      

  map.pay                      'az_companies/pay/:id', :controller => 'az_companies', :action => 'pay'
  map.billing_history          'az_companies/billing_history/:id', :controller => 'az_companies', :action => 'billing_history'
  map.change_tariff            'az_companies/change_tariff/:id',   :controller => 'az_companies', :action => 'change_tariff'
  map.set_tariff               'az_companies/set_tariff/:id',      :controller => 'az_companies', :action => 'set_tariff'


  map.store_items  'store_items/:id',        :controller => 'az_store_items', :action => 'show'
  
  map.articles      'articles',               :controller => 'az_articles', :action => 'index_public'
  map.article       'articles/:id',           :controller => 'az_articles', :action => 'show'

  map.resources :az_companies
  map.resources :az_store_items
  map.resources :az_allowed_operations
  map.resources :az_typed_page_operations
  #map.resources :az_typed_page_opertions
  map.resources :az_operation_times
  map.resources :az_operations
  map.resources :az_profiles
  map.resources :az_page_az_tasks
  map.resources :az_project_blocks
  map.resources :az_rm_roles
  map.resources :az_tasks
  map.resources :az_collection_templates
  map.resources :az_variables
  map.resources :az_struct_data_types
  map.resources :az_enum_data_types
  map.resources :az_collection_data_types
  map.resources :az_simple_data_types
  map.resources :az_base_data_types
  map.resources :az_page_az_page_types
  map.resources :az_page_types
  #map.resources :az_data_types
  map.resources :az_images
  map.resources :az_pages_types
  map.resources :az_typed_pages

  map.configuration        '/az_settings/configuration', :controller => 'az_settings', :action => 'configuration'
  map.resources :az_settings
  
  map.resources :az_user_settings
  map.resources :az_services
  map.resources :az_dashboard
  #map.resources :sessions
  #map.resources :users
  map.resources :az_designs
  #map.resources :categories
  map.resources :az_projects, :collection => { :show_design => :get }
  #map.resources :az_designs, :collection => { :add_source => :post }
  #map.resources :az_project_blocks, :collection => { :summary => :get }

  map.resources :az_projects
  map.resources :az_project_snippets
  map.resources :az_pages  
  map.resources :az_contacts
  
  map.logout            '/logout',                :controller => 'sessions',     :action => 'destroy'
  map.login             '/login',                 :controller => 'sessions',     :action => 'new'
  map.register          '/register',              :controller => 'az_users',     :action => 'create'
  map.signup            '/signup',                :controller => 'az_users',     :action => 'new'
  map.accept_la         '/accept_la',             :controller => 'az_users',     :action => 'accept_la'
  map.accept_la         '/accept_la/:choise',     :controller => 'az_users',     :action => 'accept_la'
  map.license_agreement '/license_agreement.html',:controller => 'az_users',     :action => 'license_agreement'

  map.new_employee        '/new_employee/:hash_str', :controller => 'az_users',     :action => 'new_employee'
  map.registered          '/registered',          :controller => 'az_users',     :action => 'registered'
  map.confirmed           '/confirmed',           :controller => 'az_users',     :action => 'confirmed'
  map.not_confirmed       '/not_confirmed',       :controller => 'az_users',     :action => 'not_confirmed'
  map.not_confirmed       '/change_password',     :controller => 'az_users',     :action => 'change_password'
  map.change_subscribtion '/az_users/change_subscribtion',   :controller => 'az_users',     :action => 'change_subscribtion'
  map.unsubscribe         '/unsubscribe/:id',     :controller => 'az_users',     :action => 'unsubscribe'
  map.dashboard           '/dashboard',           :controller => 'az_dashboard', :action => 'index'
  map.new_dashboard       '/new_main',            :controller => 'az_dashboard', :action => 'new_index' # TODO Kill it
  map.video               '/video/:id',           :controller => 'az_dashboard', :action => 'video'
  map.explore             '/explore',             :controller => 'az_dashboard', :action => 'explore'
  map.explore_all         '/explore/all',         :controller => 'az_dashboard', :action => 'explore_all'
  map.explore_active      '/explore/active',      :controller => 'az_dashboard', :action => 'explore_active'
  map.explore_noteworthy  '/explore/noteworthy',  :controller => 'az_dashboard', :action => 'explore_noteworthy'

  map.store             '/store',             :controller => 'az_store',     :action => 'store'
  map.store_rss         '/store/rss',         :controller => 'az_store',     :action => 'rss'
  map.update_password   '/update_password',   :controller => 'az_users',     :action => 'update_password'
  map.recover_password  '/recover_password',  :controller => 'az_users',     :action => 'recover_password'
  map.invite_to_site    '/news/:id',          :controller => 'az_news',      :action => 'show'

  #map.dashboard_test    '/test',              :controller => 'az_dashboard', :action => 'index_test'
  
  map.dashboard_tariffs '/old_tariffs',           :controller => 'az_dashboard', :action => 'tariff_test'
  map.dashboard_new_tariffs '/tariffs',   :controller => 'az_dashboard', :action => 'tariffs'

  map.dashboard_news_archive '/news_archive/:year/:month',      :controller => 'az_news', :action => 'archive'
  map.feedback          '/feedback',          :controller => 'az_messages',  :action => 'new'

  # TODO remove test
  #map.test           '/test',          :controller => 'az_users', :action => 'test'

  map.invite_to_site '/invite_to_site/:user_id', :controller => 'az_invitations', :action => 'invite_to_site'
  map.invite_to_company '/invite_to_company/:owner_id', :controller => 'az_invitations', :action => 'invite_to_company'

  map.confirm_registration '/confirm_registration/:hash_str',   :controller => 'az_users', :action => 'confirm_registration'
  map.new_password         '/new_password/:hash_str',           :controller => 'az_users', :action => 'new_password'
  map.set_new_password     '/set_new_password',       :controller => 'az_users', :action => 'set_new_password', :conditions => { :method => :put }
  
  map.users_projects_pages  '/az_users/users_projects_pages',           :controller => 'az_users', :action => 'users_projects_pages'

  map.resources :az_users

  
  map.resource :session

  map.new_sub_page        'az_pages/:az_page_id/new_sub_page',                  :controller => 'az_pages',      :action => 'new_sub_page'

  #map.add_type            'az_pages/add_type/:id/:project_id',                  :controller => 'az_pages',      :action => 'add_type'
  #map.remove_type         'az_pages/remove_type/:id/:project_id',               :controller => 'az_pages',      :action => 'remove_type'
  
  map.add_data_type       'az_pages/add_data_type/:id/:data_type_id',           :controller => 'az_pages',      :action => 'add_data_type'
  map.remove_data_type    'az_pages/remove_data_type/:id/:data_type_id',        :controller => 'az_pages',      :action => 'remove_data_type'

  #map.new_sub_page        'az_pages/new/:project_id',                           :controller => 'az_pages',      :action => 'new'
  map.create_page         'az_pages/new/:project_id',                           :controller => 'az_pages',      :action => 'new'
  map.destroy_bp          'az_pages/destroy_bp/:id',                            :controller => 'az_pages',      :action => 'destroy_bp'
  map.destroy_lnk         'az_pages/destroy_lnk/:id/:parent_page_id',           :controller => 'az_pages',      :action => 'destroy_lnk'


  map.edit_page           'az_pages/:id/edit_page',                             :controller => 'az_pages',      :action => 'edit_page'
  #map.new_sub_attribute   'az_attribute/:az_attribute_id/new_sub_attribute',    :controller => 'az_attribute',  :action => 'new_sub_attribute'
  #map.new_sub_task        'az_tasks/:az_task_id/new_sub_task',                  :controller => 'az_tasks',      :action => 'new_sub_task'
  #map.attach_snippet      'az_pages/attach_snippet/:id/:az_snippet_id',         :controller => 'az_az_pages',   :action => 'attach_snippet'
  #map.new_page_tasks      'az_pages/new_tasks/:id',                             :controller => 'az_pages',      :action => 'new_tasks'
  #map.new_page_task       'az_pages/new_task/:id/:task_id',                     :controller => 'az_pages',      :action => 'new_task'
  #map.new_project_task    'az_projects/new_task/:id/:task_id',                  :controller => 'az_projects',   :action => 'new_task'
  #map.create_page_tasks   'az_pages/create_page_tasks/:id',                     :controller => 'az_pages',      :action => 'create_page_tasks'

  map.change_members      'az_projects/change_members/:id',                     :controller => 'az_projects',   :action => 'change_members'

  map.show_project        'az_projects/show/:id/:show_type',                    :controller => 'az_projects',   :action => 'show'

  #map.show_data           'az_projects/show_data/:id',                          :controller => 'az_projects',   :action => 'show_data'
  #map.show_design         'az_projects/show_design/:id',                        :controller => 'az_projects',   :action => 'show_design'
  #map.show_blocks         'az_projects/show_blocks/:id',                        :controller => 'az_projects',   :action => 'show_blocks'
  #map.show_description    'az_projects/show_description/:id',                   :controller => 'az_projects',   :action => 'show_description'

  map.add_common          'az_projects/add_common/:id/:common_id',                   :controller => 'az_projects',   :action => 'add_common'
  map.remove_common       'az_projects/remove_common/:id/:common_id',                :controller => 'az_projects',   :action => 'remove_common'
  map.add_common_a        'az_base_projects/add_common_a/:id/:common_id',            :controller => 'az_base_projects',   :action => 'add_common_a'
  map.remove_common_a     'az_base_projects/remove_common_a/:id/:common_id',         :controller => 'az_base_projects',   :action => 'remove_common_a'
  map.add_definition      'az_projects/add_definition/:id/:definition_id',           :controller => 'az_projects',   :action => 'add_definition'
  map.remove_definition   'az_projects/remove_definition/:id/:definition_id',        :controller => 'az_projects',   :action => 'remove_definition'
  map.add_definition_a    'az_base_projects/add_definition_a/:id/:definition_id',    :controller => 'az_base_projects',   :action => 'add_definition_a'
  map.remove_definition_a 'az_base_projects/remove_definition_a/:id/:definition_id', :controller => 'az_base_projects',   :action => 'remove_definition_a'
  map.move_definition_up_tr   'az_base_projects/move_definition_up_tr/:id/:definition_id',   :controller => 'az_base_projects',   :action => 'move_definition_up_tr'
  map.move_definition_down_tr 'az_base_projects/move_definition_down_tr/:id/:definition_id', :controller => 'az_base_projects',   :action => 'move_definition_down_tr'
  map.move_common_up_tr   'az_base_projects/move_common_up_tr/:id/:common_id',       :controller => 'az_base_projects',   :action => 'move_common_up_tr'
  map.move_common_down_tr 'az_base_projects/move_common_down_tr/:id/:common_id',     :controller => 'az_base_projects',   :action => 'move_common_down_tr'
  map.tr_commons_content  'az_base_projects/tr_commons_content/:id/:common_class',   :controller => 'az_base_projects',   :action => 'tr_commons_content'

  map.tr_sort_public_pages  'az_projects/tr_sort_public_pages/:id',             :controller => 'az_projects',   :action => 'tr_sort_public_pages'
  map.tr_sort_admin_pages   'az_projects/tr_sort_admin_pages/:id',              :controller => 'az_projects',   :action => 'tr_sort_admin_pages'
  
  map.tr_collapse_admin_pages   'az_projects/tr_collapse_admin_pages/:id',      :controller => 'az_projects',   :action => 'tr_collapse_admin_pages'
  map.tr_expand_admin_pages     'az_projects/tr_expand_admin_pages/:id',        :controller => 'az_projects',   :action => 'tr_expand_admin_pages'
  map.tr_collapse_public_pages  'az_projects/tr_collapse_public_pages/:id',     :controller => 'az_projects',   :action => 'tr_collapse_public_pages'
  map.tr_expand_public_pages    'az_projects/tr_expand_public_pages/:id',       :controller => 'az_projects',   :action => 'tr_expand_public_pages'

  map.test_pages_list    'az_projects/test_pages_list/:id',       :controller => 'az_projects',   :action => 'test_pages_list'

  #map.show                'az_project_blocks/show/:id/:show_type',                  :controller => 'az_project_blocks', :action => 'show'
  map.show_project_block   'az_project_blocks/show/:id/:show_type',                 :controller => 'az_project_blocks',   :action => 'show'
  #map.show_data           'az_project_blocks/show_data/:id',                        :controller => 'az_project_blocks', :action => 'show_data'
  #map.show_design         'az_project_blocks/show_design/:id',                      :controller => 'az_project_blocks', :action => 'show_design'
  #map.show_description    'az_project_blocks/show_description/:id',                 :controller => 'az_project_blocks', :action => 'show_description'
  map.add_definition      'az_project_blocks/add_definition/:id/:definition_id',    :controller => 'az_projects',       :action => 'add_definition'
  map.remove_definition   'az_project_blocks/remove_definition/:id/:definition_id', :controller => 'az_projects',       :action => 'remove_definition'

  # ----- new -----
  # TODO много new. WTF?
  map.new                 'az_projects/new/:owner_id',                            :controller => 'az_projects',              :action => 'new'
  map.new                 'az_struct_data_types/new/:owner_id',                   :controller => 'az_struct_data_types',     :action => 'new'
  map.new                 'az_struct_data_types/new/:owner_id/:az_base_project_id', :controller => 'az_struct_data_types',   :action => 'new'
  map.copy_and_attach_to_project 'az_struct_data_types/copy_and_attach_to_project/:id/:project_id', :controller => 'az_struct_data_types',   :action => 'copy_and_attach_to_project'
  map.copy_struct_to_stock 'az_struct_data_types/copy_to_stock/:id',              :controller => 'az_struct_data_types',     :action => 'copy_to_stock'
  
  map.new                 'az_definitions/new/:owner_id',                         :controller => 'az_definitions',           :action => 'new'
  map.new                 'az_definitions/new/:owner_id/:az_base_project_id',     :controller => 'az_definitions',           :action => 'new'
  map.tr_new_definition_dialog 'az_definitions/tr_new_definition_dialog/:owner_id/:az_base_project_id', :controller => 'az_definitions', :action => 'tr_new_definition_dialog'
  map.create_definition  'az_definitions/create_definition/:owner_id',            :controller => 'az_definitions', :action => 'create_definition'

  map.new                 'az_validators/new/:owner_id',                          :controller => 'az_validators',           :action => 'new'
  map.new                 'az_validators/new/:owner_id/:az_variable_id',          :controller => 'az_validators',           :action => 'new'

  map.move_up_az_page     'az_variables/move_up/:id',                             :controller => 'az_variables',            :action => 'move_up'
  map.move_down_az_page   'az_variables/move_down/:id',                           :controller => 'az_variables',            :action => 'move_down'
  map.new                 'az_variables/new/:az_struct_data_type_id',             :controller => 'az_variables',             :action => 'new'
  #map.new                 'az_collection_data_types/new/:owner_id',               :controller => 'az_collection_data_types', :action => 'new'
  map.new                 'az_collection_data_types/new/:az_base_data_type_id',   :controller => 'az_collection_data_types', :action => 'new'
  map.new                 'az_tasks/new/:owner_id',                               :controller => 'az_tasks',                 :action => 'new'
  map.new_tr_text         'az_tr_texts/new/:owner_id',                            :controller => 'az_tr_texts',              :action => 'new'
  map.new                 'az_project_blocks/new/:owner_id',                      :controller => 'az_project_blocks',        :action => 'new'
  map.copy                'az_project_blocks/copy/:id/:owner_id',                 :controller => 'az_project_blocks',        :action => 'copy'
  map.fork_block          'az_project_blocks/fork/:id/:owner_id',                 :controller => 'az_project_blocks',        :action => 'fork'
  map.copy                'az_projects/copy/:id/:owner_id',                       :controller => 'az_projects',              :action => 'copy'
  map.fork_project        'az_projects/fork/:id/:owner_id',                       :controller => 'az_projects',              :action => 'fork'
  map.real_fork_project   'az_projects/real_fork/:id/:owner_id',                  :controller => 'az_projects',              :action => 'real_fork'

    #map.new                 'az_operation_times/new/:data_type_id',                 :controller => 'az_operation_times',       :action => 'new'


  map.new_common          'commons/new/:owner_id',                                :controller => 'az_commons_commons',       :action => 'new'
  map.new_purpose_expl    'purpose_exploitations/new/:owner_id',                  :controller => 'az_commons_purpose_exploitations', :action => 'new'
  map.new_purpose_func    'purpose_functional/new/:owner_id',                     :controller => 'az_commons_purpose_functionals',   :action => 'new'
  map.new_requirements_hosting     'requirements_hosting/new/:owner_id',          :controller => 'az_commons_requirements_hostings', :action => 'new'
  map.new_requirements_reliability 'requirements_reliability/new/:owner_id',      :controller => 'az_commons_requirements_reliabilities', :action => 'new'
  map.new_acceptance_conditions    'acceptance_conditions/new/:owner_id',         :controller => 'az_commons_acceptance_conditions', :action => 'new'
  map.new_content_creation         'content_creation/new/:owner_id',              :controller => 'az_commons_content_creations', :action => 'new'

  map.new_common                   'commons/new/:owner_id/:az_base_project_id',                       :controller => 'az_commons_commons',                    :action => 'new'
  map.new_purpose_expl             'purpose_exploitations/new/:owner_id/:az_base_project_id',         :controller => 'az_commons_purpose_exploitations',      :action => 'new'
  map.new_purpose_func             'purpose_functional/new/:owner_id/:az_base_project_id',            :controller => 'az_commons_purpose_functionals',        :action => 'new'
  map.new_requirements_hosting     'requirements_hosting/new/:owner_id/:az_base_project_id',          :controller => 'az_commons_requirements_hostings',      :action => 'new'
  map.new_requirements_reliability 'requirements_reliability/new/:owner_id/:az_base_project_id',      :controller => 'az_commons_requirements_reliabilities', :action => 'new'
  map.new_acceptance_conditions    'acceptance_conditions/new/:owner_id/:az_base_project_id',         :controller => 'az_commons_acceptance_conditions',      :action => 'new'
  map.new_content_creation         'content_creation/new/:owner_id/:az_base_project_id',              :controller => 'az_commons_content_creations',          :action => 'new'

  #map.tr_new_common                   'commons/new/:owner_id/:az_base_project_id',                       :controller => 'az_commons_commons',                    :action => 'new'
  map.tr_new_purpose_comm             'az_commons_commons/tr_new_dialog/:owner_id/:az_base_project_id',         :controller => 'az_commons_commons',      :action => 'tr_new_dialog'
  map.tr_new_purpose_expl             'az_commons_purpose_exploitations/tr_new_dialog/:owner_id/:az_base_project_id',         :controller => 'az_commons_purpose_exploitations',      :action => 'tr_new_dialog'
  map.tr_new_purpose_func             'az_commons_purpose_functionals/tr_new_dialog/:owner_id/:az_base_project_id',         :controller => 'az_commons_purpose_functionals',      :action => 'tr_new_dialog'

  map.tr_new_functionalities           'az_commons_functionalities/tr_new_dialog/:owner_id/:az_base_project_id',         :controller => 'az_commons_functionalities',      :action => 'tr_new_dialog'

  map.tr_new_purpose_expl             'az_commons_content_creations/tr_new_dialog/:owner_id/:az_base_project_id',         :controller => 'az_commons_content_creations',      :action => 'tr_new_dialog'
  map.tr_new_purpose_expl             'az_commons_requirements_hostings/tr_new_dialog/:owner_id/:az_base_project_id',         :controller => 'az_commons_requirements_hostings',      :action => 'tr_new_dialog'
  map.tr_new_purpose_expl             'az_commons_requirements_reliabilities/tr_new_dialog/:owner_id/:az_base_project_id',         :controller => 'az_commons_requirements_reliabilities',      :action => 'tr_new_dialog'
  map.tr_new_purpose_expl             'az_commons_acceptance_conditions/tr_new_dialog/:owner_id/:az_base_project_id',         :controller => 'az_commons_acceptance_conditions',      :action => 'tr_new_dialog'

#  map.tr_new_purpose_func             'purpose_functional/new/:owner_id/:az_base_project_id',            :controller => 'az_commons_purpose_functionals',        :action => 'new'
#  map.tr_new_requirements_hosting     'requirements_hosting/new/:owner_id/:az_base_project_id',          :controller => 'az_commons_requirements_hostings',      :action => 'new'
#  map.tr_new_requirements_reliability 'requirements_reliability/new/:owner_id/:az_base_project_id',      :controller => 'az_commons_requirements_reliabilities', :action => 'new'
#  map.tr_new_acceptance_conditions    'acceptance_conditions/new/:owner_id/:az_base_project_id',         :controller => 'az_commons_acceptance_conditions',      :action => 'new'
#  map.tr_new_content_creation         'content_creation/new/:owner_id/:az_base_project_id',              :controller => 'az_commons_content_creations',          :action => 'new'

  map.struct_move_up                'az_struct_data_types/move_up/:id',             :controller => 'az_struct_data_types',    :action => 'move_up'
  map.struct_move_down              'az_struct_data_types/move_down/:id',           :controller => 'az_struct_data_types',    :action => 'move_down'
  map.struct_move_up_tr             'az_struct_data_types/move_up_tr/:id',          :controller => 'az_struct_data_types',    :action => 'move_up_tr'
  map.struct_move_down_tr           'az_struct_data_types/move_down_tr/:id',        :controller => 'az_struct_data_types',    :action => 'move_down_tr'

#  map.common_up_tr                 'az_commons/move_up_tr/:id',                   :controller => 'az_commons',      :action => ':move_up_tr'
#  map.common_down_tr               'az_commons/move_down_tr/:id',                 :controller => 'az_commons',      :action => ':move_down_tr'
#  map.common_up                    'az_commons/move_up/:id',                      :controller => 'az_commons',      :action => ':move_up'
#  map.common_down                  'az_commons/move_down/:id',                    :controller => 'az_commons',      :action => ':move_down'


  map.guest_show                'az_projects/guest_show/:hash_str',               :controller => 'az_projects',   :action => 'guest_show'
  map.show_tr                   'az_projects/show_tr/:id',                        :controller => 'az_projects',   :action => 'show_tr'
  map.show_tr                   'az_projects/show_tr/:id',                        :controller => 'az_projects',   :action => 'show_tr'

  

  map.show_sub_tree1            'az_projects/show_sub_tree/:id/:parent_page_id/:page_id/:show_type',         :controller => 'az_projects',   :action => 'show_sub_tree'
  map.show_sub_tree2            'az_project_blocks/show_sub_tree/:id/:parent_page_id/:page_id/:show_type',   :controller => 'az_project_blocks',   :action => 'show_sub_tree'
  map.show_sub_tree21            'az_projects/show_sub_tree2/:id/:page_id/:show_type',         :controller => 'az_projects',   :action => 'show_sub_tree2'
  map.show_sub_tree22            'az_project_blocks/show_sub_tree2/:id/:page_id/:show_type',   :controller => 'az_project_blocks',   :action => 'show_sub_tree2'
  
  #map.show_tr_with_out_controls 'az_projects/show_tr_with_out_controls/:id',      :controller => 'az_projects',   :action => 'show_tr_with_out_controls'
  #map.show_tr_with_controls     'az_projects/show_tr_with_controls/:id',          :controller => 'az_projects',   :action => 'show_tr_with_controls'
  map.show_pure_tr              'az_projects/show_pure_tr/:id',                   :controller => 'az_projects',   :action => 'show_pure_tr'
  map.show_pure_tr_md           'az_projects/show_pure_tr_md/:id',                :controller => 'az_projects',   :action => 'show_pure_tr_md'
  
  map.add_component             'az_projects/add_component/:id/:az_project_block_id',    :controller => 'az_projects', :action => 'add_component'
  map.remove_component          'az_projects/remove_component/:id/:az_project_block_id', :controller => 'az_projects', :action => 'remove_component'
  
  map.data_box             'az_projects/data_box/:id',                            :controller => 'az_projects',   :action => 'data_box'


  map.update_design        'az_designs/update_design/:id',                        :controller => 'az_designs',    :action => 'update_design'
  map.new_design           'az_designs/new_design/:id',                           :controller => 'az_designs',    :action => 'new_design'
  map.add_source           'az_designs/add_source/:id/:design_rnd',               :controller => 'az_designs',    :action => 'add_source'
  map.create_source        'az_designs/create_source/:id',                        :controller => 'az_designs',    :action => 'create_source'

  map.designs_tooltip      'az_pages/designs_tooltip/:id',                        :controller => 'az_pages',      :action => 'designs_tooltip'
  map.create_design        'az_pages/design/:id',                                 :controller => 'az_pages',      :action => 'new_design'

  
  map.page_box_with_mode   'az_pages/page_box/:id/:show_mode',                    :controller => 'az_pages',      :action => 'page_box'
  map.page_box             'az_pages/page_box/:id',                               :controller => 'az_pages',      :action => 'page_box'
  map.page_box3            'az_pages/page_box3/:id/:link_id/:show_mode',          :controller => 'az_pages',      :action => 'page_box3'
  
  # TODO много attach_page_to_page. WTF?
  map.add_page_parent      'az_pages/add_page_parent/:id/:parent_id',             :controller => 'az_pages',      :action => 'add_page_parent'
  map.change_page_parent   'az_pages/change_page_parent/:id/:link_id/:new_parent_id', :controller => 'az_pages',      :action => 'change_page_parent'

  #map.attach_page_to_page  'az_pages/attach_page_to_page/:id',                    :controller => 'az_pages',      :action => 'attach_page_to_page'
  map.attach_page_to_page  'az_pages/set_functionality_source/:id/:source_id',    :controller => 'az_pages',      :action => 'set_functionality_source'
  map.attach_page_to_page  'az_pages/set_functionality_source/:id',               :controller => 'az_pages',      :action => 'set_functionality_source'
  map.attach_page_to_page  'az_pages/set_design_source/:id/:source_id',           :controller => 'az_pages',      :action => 'set_design_source'
  map.attach_page_to_page  'az_pages/set_design_source/:id',                      :controller => 'az_pages',      :action => 'set_design_source'
  map.get_description1     'az_pages/get_page_description1/:id/:tr_text_id/:data_type_id', :controller => 'az_pages',  :action => 'get_page_description1'


  #map.create_catalog      'catalogs/:az_project_id/new',                         :controller => 'catalogs',      :action => 'new'
  #map.create_category     'categories/:catalog_id/new',                          :controller => 'categories',    :action => 'new'
  #map.create_subcategory  'categories/:parent_id/new_sub',                       :controller => 'categories',    :action => 'new_sub'

  map.create_image          'az_images/:design_rnd',                               :controller => 'az_images',          :action => 'create'
  map.destroy_image_by_rnd  'az_images/destroy_by_rnd/:rnd',                       :controller => 'az_images',          :action => 'destroy_by_rnd'
  #map.tr_doc_show           'az_images/tr_doc_show/:id',                           :controller => 'az_images',          :action => 'tr_doc_show'
  map.destroy_source_by_rnd 'az_design_sources/destroy_by_rnd/:rnd',               :controller => 'az_design_sources',  :action => 'destroy_by_rnd'
    
  #map.create_design az_designs

  #map.create_category 'categories/:back_controller/:back_item_id/:catalog_id/new', :controller => 'categories', :action => 'new'
  #map.edit_category1 'categories/:back_controller/:back_item_id/:id/edit', :controller => 'categories', :action => 'edit'
  #map.show_category1 'categories/:back_controller/:back_item_id/:id/show', :controller => 'categories', :action => 'show'

  map.summary                 'az_project_blocks/summary/:id',                   :controller => 'az_project_blocks',  :action => 'summary'

  map.show_task_list          'az_projects/show_task_list/:id', :controller => 'az_projects',  :action => 'show_task_list'
  #map.get_scheme             'az_projects/get_scheme/:id',     :controller => 'az_projects',  :action => 'get_scheme'
  #map.add_worker             'az_projects/add_worker/:id',     :controller => 'az_projects',  :action => 'add_worker'
  #map.remove_worker          'az_projects/add_worker/:id',     :controller => 'az_projects',  :action => 'remove_worker'

  #map.new_sub_page         'az_pages/move_up/:id',     :controller => 'az_pages', :action => 'move_up'
  map.move_up_az_page       'az_pages/move_up/:id/:parent_page_id',      :controller => 'az_pages', :action => 'move_up'
  map.move_down_az_page     'az_pages/move_down/:id/:parent_page_id',    :controller => 'az_pages', :action => 'move_down'
  map.move_tr_up_az_page     'az_pages/move_tr_up/:id/:positions',      :controller => 'az_pages', :action => 'move_tr_up'
  map.move_tr_down_az_page   'az_pages/move_tr_down/:id/:positions',    :controller => 'az_pages', :action => 'move_tr_down'
  #map.create_tasks_az_page  'az_pages/create_tasks/:id', :controller => 'az_pages', :action => 'create_tasks'
  #map.add_block             'az_pages/add_block/:id/:az_project_block_id',    :controller => 'az_pages', :action => 'add_block'
  #map.remove_block          'az_pages/remove_block/:id/:az_project_block_id', :controller => 'az_pages', :action => 'remove_block'
  map.attach_component_page 'az_pages/attach_component_page/:id/:component_page_id', :controller => 'az_pages', :action => 'attach_component_page'
  map.remove_component_page 'az_pages/remove_component_page/:id/:component_page_id', :controller => 'az_pages', :action => 'remove_component_page'

  map.description_wo_title_dialog     'az_pages/description_wo_title_dialog/:id/:update_page_id',     :controller => 'az_pages', :action => 'description_wo_title_dialog'
  map.tr_description_wo_title_tooltip 'az_pages/tr_description_wo_title_tooltip/:id/:update_page_id', :controller => 'az_pages', :action => 'tr_description_wo_title_tooltip'
  map.tr_description_tooltip          'az_pages/tr_description_tooltip/:id',                      :controller => 'az_pages', :action => 'tr_description_tooltip'
  map.tr_page_status_dialog           'az_pages/tr_page_status_dialog/:id/:project_id',           :controller => 'az_pages', :action => 'tr_page_status_dialog'
 

  #map.move_up_contact_form   'contact_forms/move_up/:id',   :controller => 'contact_forms', :action => 'move_up'
  #map.move_down_contact_form 'contact_forms/move_down/:id', :controller => 'contact_forms', :action => 'move_down'

  map.copy_az_collection_data_type 'az_collection_data_type/copy/:id',  :controller => 'az_collection_data_types', :action => 'copy'
  map.copy_az_variable             'az_variable/copy/:id',              :controller => 'az_variables',             :action => 'copy'
  map.copy_az_struct_data_type     'az_struct_data_type/copy/:id',      :controller => 'az_struct_data_types',     :action => 'copy'
  #map.copy_az_page                 'az_page/copy/:id',                  :controller => 'az_pages',                 :action => 'copy'


  map.structs              'structs',               :controller => 'az_struct_data_types',             :action => 'index_user'
  map.settings             'settings',              :controller => 'az_user_settings',                 :action => 'index'
  map.seeds                'seeds',                 :controller => 'az_settings',                      :action => 'seeds'
  

  map.projects             'projects',              :controller => 'az_projects',                      :action => 'index_user'
  map.definitions          'definitions',           :controller => 'az_definitions',                   :action => 'index_user'
  map.profile              'profile',               :controller => 'az_profiles',                      :action => 'index'
  map.employees            'employees',             :controller => 'az_employees',                     :action => 'index_user'
  map.components           'components',            :controller => 'az_project_blocks',                :action => 'index_user'
  map.tasks                'tasks',                 :controller => 'az_tasks',                         :action => 'index_user'
  map.tr_texts             'tr_texts',              :controller => 'az_tr_texts',                      :action => 'index_user'
  map.contacts             'contacts',              :controller => 'az_contacts',                      :action => 'index_user'
  map.validators           'validators',            :controller => 'az_validators',                    :action => 'index_user'
  map.commons                  'commons',                  :controller => 'az_commons_commons',                    :action => 'index_user'
  map.purpose_expl             'purpose_exploitations',    :controller => 'az_commons_purpose_exploitations',      :action => 'index_user'
  map.purpose_func             'purpose_functionals',      :controller => 'az_commons_purpose_functionals',        :action => 'index_user'
  map.functionality            'functionality',            :controller => 'az_commons_functionalities',            :action => 'index_user'
  map.requirements_hosting     'requirements_hosting',     :controller => 'az_commons_requirements_hostings',      :action => 'index_user'
  map.requirements_reliability 'requirements_reliability', :controller => 'az_commons_requirements_reliabilities', :action => 'index_user'
  map.acceptance_conditions    'acceptance_conditions',    :controller => 'az_commons_acceptance_conditions',      :action => 'index_user'
  map.content_creation         'content_creation',         :controller => 'az_commons_content_creations',          :action => 'index_user'
  map.enums                    'enums',                    :controller => 'az_enums',                              :action => 'index_user'

  map.guest_links              'guest_links',              :controller => 'az_guest_links/:project_id',            :action => 'index_project'
  map.new_guest_links          'guest_links/new/:id',      :controller => 'az_guest_links/:project_id',            :action => 'new'


  map.new_guest_links          'az_typed_pages/operations_dialog/:id',      :controller => 'az_typed_pages',       :action => 'operations_dialog'
  map.update_operations        'az_typed_pages/update_operations/:id',      :controller => 'az_typed_pages',       :action => 'update_operations'

  map.buy                       'az_store_items/buy/:id/:company_id',       :controller => 'az_store_items', :action => 'buy'

  map.connect 'az_activities/active_companies', :controller => 'az_activities', :action => 'active_companies'
  map.connect 'az_activities/active_projects', :controller => 'az_activities', :action => 'active_projects'



  #map.create_category2 'categories/:project_id/:catalog_id/new', :controller => 'categories', :action => 'new'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'


  #map.index 'index', :controller => "az_projects", :action => "index_user"
  map.index 'index', :controller => "az_dashboard", :action => "index"
  map.root :index
  
end
