authorization do

  role :admin do
    includes :user
    has_permission_on [:az_activities], :to => [:index, :manage, :active_companies, :active_projects]
    has_permission_on [:az_pages], :to => [:manage_page, :index]
    has_permission_on [:az_users], :to => [:index, :show, :new, :create, :edit, :update, :destroy, :users_projects_pages]
    has_permission_on [:az_settings], :to => [:index, :seeds, :configuration]
    has_permission_on [:az_definitions], :to => [:index]
    has_permission_on [:az_commons, :az_commons_commons, :az_commons_purpose_exploitations,
                       :az_commons_purpose_functionals, :az_commons_requirements_hosting,
                       :az_commons_requirements_reliability, :az_commons_acceptance_conditions,
                       :az_commons_content_creation,
                       :az_struct_data_types], :to => [:index, :manage]

    has_permission_on [:az_projects, :az_project_blocks], :to => [:index, :manage_project, :show_pure_tr]


    has_permission_on [:az_simple_data_types], :to => [:index, :manage]
    has_permission_on [:az_struct_data_types], :to => [:copy]
    has_permission_on [:az_rm_roles], :to => [:index, :manage]
    has_permission_on [:az_operations], :to => [:index, :manage]
    has_permission_on [:az_operation_times], :to => [:index, :manage]
    has_permission_on [:az_companies], :to => [:index, :manage_company, :index_ceo_note, :create, :destroy, :admin_show]
    has_permission_on [:az_services], :to => [:index,
                                              :update_from_seeds,
                                              :su,
                                              :make_copy,
                                              :update_validators_from_seed,
                                              :update_definitions_from_seed,
                                              :update_az_common_from_seed,
                                              :update_az_project_from_seed,
                                              :delete_seeded_project_blocks,
                                              :update_az_project_block_from_seed
                                              ]
    has_permission_on [:az_news, :az_collection_templates], :to => [:index, :manage]
    has_permission_on [:az_project_statuses], :to => [:index, :manage]
    has_permission_on [:az_guest_links], :to => [:index]

    has_permission_on [:az_messages], :to => [:index, :manage, :set_filter]
    has_permission_on [:az_images, :az_designs], :to => [:index]
      
    has_permission_on [:az_tariffs], :to => [:index, :manage]
    has_permission_on [:az_balance_transactions], :to => [:index, :edit, :update, :show]
    has_permission_on [:az_tariff_limits], :to => [:index, :manage]
    has_permission_on [:az_tariff_limit_types], :to => [:index, :manage]
    has_permission_on [:az_register_confirmations], :to => [:resend]
    has_permission_on [:az_store], :to => [:store, :rss]
    has_permission_on [:az_store_items], :to => [:index, :manage, :not_enough_money_dialog, :select_company_dialog]
    has_permission_on [:az_store_item_scetches], :to => [:index, :manage]
    has_permission_on [:az_purchases], :to => [:index, :manage]
    has_permission_on [:az_languages], :to => [:index, :manage]
    has_permission_on [:az_scetch_programs], :to => [:index, :manage]
    has_permission_on [:az_test_periods, :az_warning_periods], :to => [:index, :manage]
    has_permission_on [:az_articles], :to => [:index, :manage]

  end

  role :nobody do
  end

  role :user do
    includes :guest
    has_permission_on [:az_payments], :to => [:result_lp] # TODO удалить, только гость может

    has_permission_on [:az_projects, :az_project_blocks], :to => [:index_user, :create, :components_dialog]
    #has_permission_on [:az_projects, :az_project_blocks], :to => [:index_user, :create, :destroy, :components_dialog]
    
    has_permission_on [:az_projects], :to => [:manage_project, :test_pages_list, :activity] do
      if_attribute :owner_id => is_in {user.my_works_ids},
                   :ar_project_participant_user_ids => intersects_with {[user.id]},
                   :is_active? => true,
                   :can_be_managed => true,
                   :owner => {:get_locked => is {false}}
    end

    has_permission_on [:az_project_blocks], :to => [:manage_project, :summary] do
      if_attribute :owner_id => is_in {user.my_works_ids}, :owner => {:get_locked => is {false}}
    end

    has_permission_on [:az_base_projects], :to => [:add_definition_a, :remove_definition_a,
                                                   :add_common_a, :remove_common_a,
                                                   :tr_commons_content, :tr_definitions_content,
                                                   :datatype_list,
                                                   :move_definition_up_tr, :move_definition_down_tr, :move_common_up_tr, :move_common_down_tr] do
      if_attribute :owner => is_in {user.my_works}
    end

    has_permission_on [:az_projects, :az_project_blocks], :to => [:manage_projects] do
      if_attribute :owner => is_in {user.az_companies}
    end

    has_permission_on [:az_projects], :to => [:copy] do
      if_attribute :owner => is_in {user.az_companies}
    end

    has_permission_on [:az_projects, :az_project_blocks], :to => [:fork, :real_fork] do
      if_attribute :public_access => true
      if_attribute :owner => is_in {user.az_companies}
    end

    has_permission_on [:az_project_blocks], :to => [:copy] do
      if_attribute :owner => is_in {user.az_companies}
    end
    
    has_permission_on [:az_projects], :to => [:status_edit_dialog, :update_status] do
      if_attribute :owner => is_in {user.az_companies}
    end

    has_permission_on [:az_base_projects], :to => [:access_edit_dialog, :change_public_access] do
      if_attribute :owner => is_in {user.az_companies}
    end

    has_permission_on [:az_companies], :to => [:manage_company, :waiting_payments, :billing_history, :change_tariff, :set_tariff] do #, :make_payment, :pay, :billing_history
      if_attribute :ceo_id => is {user.id}
    end

    has_permission_on [:az_companies], :to => [:select_company_dialog]


    has_permission_on [:az_payments], :to => [:new, :create, :start, :show, :destroy, :waiting_payments, :show_payment_result_lp] do #, :make_payment, :pay, :billing_history
      if_attribute :ceo_id => is {user.id}
    end

    has_permission_on [:az_pages], :to => [:manage_page] do
      if_attribute :owner => is_in {user.my_works}
    end
    
    has_permission_on [:az_pages], :to => [:collapse_node, :expand_node] # Всегда можно свернуть-развернуть, т.к. это касается только сессии

    has_permission_on [:az_contacts], :to => :manage
    has_permission_on [:az_user_settings_controller], :to => [:index]

    has_permission_on [:az_definitions, :az_tr_texts, :az_variables, :az_validators], :to => :index_user

    has_permission_on [:az_tr_texts], :to => [:manage, :move_up, :move_down] do
      if_attribute :owner => is_in {user.my_works}
    end

    has_permission_on [:az_variables, :az_validators], :to => [:manage, :add_validator, :remove_validator] do
      if_attribute :owner => is_in {user.my_works}
    end

    has_permission_on [:az_definitions], :to => [:manage, :move_down, :move_up,
                                                 :description_text_dialog, :update_description,
                                                 :status_dialog, :update_status,
                                                 :tr_new_definition_dialog, :create_definition] do
      if_attribute :owner => is_in {user.my_works}
    end

    has_permission_on [:az_variables], :to => [:move_down, :move_up, :show_new_variable_dialog, :show_edit_variable_dialog] do
      if_attribute :owner => is_in {user.my_works}
    end

    has_permission_on [:az_struct_data_types], :to => :index_user
    has_permission_on [:az_struct_data_types], :to => [:manage, :info_tooltip, :copy_and_attach_to_project, :variables_list, 
                                                       :move_up, :move_down,
                                                       :move_up_tr, :move_down_tr,
                                                       :status_dialog, :update_status,
                                                       :copy_to_stock] do
      if_attribute :owner => is_in {user.my_works}
    end

    has_permission_on [:az_collection_data_types], :to => [:manage, :info_tooltip] do
      if_attribute :owner => is_in {user.my_works}
    end


    has_permission_on [:az_commons_content_creations,
                       :az_commons_acceptance_conditions,
                       :az_commons_requirements_reliabilities,
                       :az_commons_requirements_hostings,
                       :az_commons_purpose_functionals,
                       :az_commons_purpose_exploitations,
                       :az_commons_functionalities,
                       :az_commons_commons], :to => :index_user

    has_permission_on [:az_commons_content_creations,
                       :az_commons_acceptance_conditions,
                       :az_commons_requirements_reliabilities,
                       :az_commons_requirements_hostings,
                       :az_commons_purpose_functionals,
                       :az_commons_purpose_exploitations,
                       :az_commons_functionalities,
                       :az_commons_commons], :to => [:manage, :tr_new_dialog, :tr_create, 
                                                     :move_down, :move_up,
                                                     :description_text_dialog,
                                                     :update_description,
                                                     :status_dialog,
                                                     :update_status] do
      if_attribute :owner => is_in{user.my_works}
    end

    has_permission_on [:az_profiles], :to => :index

    has_permission_on [:az_designs], :to => [:new_design, :create, :update_design, :update, :destroy2, :new_source, :create_source] do
      #if_attribute :owner => is_in{user.my_works}
      #if_attribute :owner => Authorization.current_user.my_works
    end

    has_permission_on [:az_designs], :to => [:add_source] do
      #if_attribute :owner => is_in{user.my_works}
      #if_attribute :owner => Authorization.current_user.my_works
      if_attribute :can_be_uploaded => is { true } #TODO
    end
    
    has_permission_on [:az_images], :to => [:create, :new, :show, :destroy_by_rnd, :tr_doc_show] do
      #if_attribute :owner => Authorization.current_user.my_works
    end

    has_permission_on [:az_user_settings], :to => :index
    has_permission_on [:az_employees], :to => [:manage, :enable, :disable, :dismiss] do
      if_attribute :az_company_id => is_in { user.my_works_ids }
    end


    has_permission_on [:az_allowed_operations], :to => [:create]

    has_permission_on [:az_invitations], :to => [:invite_to_site, 
                                                 :invite_to_company,
                                                 :create_invitation_to_company,
                                                 :create_invitation_to_site,
                                                 :accept, :reject,
                                                 :resend_invitation_to_site]

    has_permission_on [:az_invitations], :to => [:delete_invitation] do
      if_attribute :ar_owner_ceo_id => is { user.id }
    end
    
    #has_permission_on [:az_users], :to => [:manage] do
    #  if_attribute :id => 3 #Authorization.current_user.id
    #end

#    has_permission_on :az_users, :to => :edit  do
#      if_attribute :id => lt { 10 }
#    end


    has_permission_on [:az_users], :to => [:manage] do
      #if_attribute :id => Authorization.current_user.id
    end

    has_permission_on [:az_users], :to => [:change_password, :update_password, :recover_password, :reset_password, 
                                           :change_subscribtion, :unsubscribe,
                                           :hide_warning_message, :accept_la, :license_agreement, :confirmed]

    has_permission_on [:az_news], :to => [:show, :archive]

    has_permission_on [:az_guest_links], :to => [:index_project]
    has_permission_on [:az_guest_links], :to => [:manage] do
      if_attribute :owner => is_in{user.my_works}
    end

    has_permission_on [:az_typed_pages], :to => [:operations_dialog, :update_operations]

    has_permission_on [:az_messages], :to => [:new, :create, :created]

    has_permission_on [:az_store], :to => [:store, :rss]
    
    has_permission_on [:az_store_items], :to => [:show, :not_enough_money_dialog, :select_company_dialog] do
      if_attribute :visible => true
    end

    has_permission_on [:az_store_items], :to => [:buy] do
      if_attribute :visible => true
    end

    has_permission_on [:az_articles], :to => [:show, :index_public]
    
  end

  role :visitor do
    includes :guest
    #has_permission_on [:az_projects], :to => [:show_design, :show_data, :show_blocks, :show_description]

    has_permission_on :az_base_projects, :to => [:tr_commons_content, 
                                                 :tr_definitions_content, :tr_structs_validators_content # Используется при обновлении (refresh) блоков в тз для виситёра
                                                ] do
      if_attribute :id => is_in {user.guest_project_ids}
    end
    has_permission_on :az_projects, :to => [:show, :edit_tr, :show_tr, :tr_commons_content, :tr_definitions_content, :tr_structs_validators_content] do
      if_attribute :id => is_in {user.guest_project_ids}
    end

    has_permission_on :az_pages, :to => [:show, 
                                         :designs_tooltip,
                                         :description_dialog,
                                         :description_wo_title_dialog,
                                         :download_designs_dialog,
                                         :collapse_node,
                                         :expand_node,
                                         :page_tr #Обновление страницы в ТЗ
                                       ] do
      if_attribute :belongs_to_project => is_in {user.guest_project_ids}
    end
    has_permission_on [:az_articles], :to => [:show, :index_public]
  end

  role :guest do
    has_permission_on [:az_projects], :to => [:guest_show,
                                              #:show_design,
                                              #:show_data,
                                              #:show_blocks,
                                              #:show_description
                                              ]

    has_permission_on [:az_users], :to => [:new, :new_employee, :create, :update,
                       :registered, :confirm_registration, :confirmed, :not_confirmed, :hide_warning_message,
                       :recover_password, :reset_password, :new_password, :set_new_password, :license_agreement, :unsubscribe]
    has_permission_on [:az_news], :to => [:show, :archive]
    has_permission_on [:az_messages], :to => [:new, :create, :created]


    has_permission_on [:az_projects, :az_project_blocks, :az_base_projects], :to => [:show,
                                                                                     :edit_tr,
                                                                                     :tr_definitions_content, :tr_structs_validators_content, :tr_commons_content# Используется при обновлении (refresh) блоков в тз для гостя
                                                                                    ] do
      if_attribute :public_access => is {true}
    end

    has_permission_on :az_pages, :to => [:show,
                                         :designs_tooltip,
                                         :description_dialog,
                                         :description_wo_title_dialog,
                                         :download_designs_dialog,
                                         :collapse_node,
                                         :expand_node,
                                         :page_tr #Обновление страницы в ТЗ
                                       ] do
      if_attribute :has_public_access => is {true}
    end

    has_permission_on [:az_typed_pages], :to => :operations_dialog # TODO WTF?

    has_permission_on [:az_payments], :to => [:result_lp]

    has_permission_on [:az_store], :to => [:store, :rss]
    has_permission_on [:az_store_items], :to => [:show] do
      if_attribute :visible => true
    end
    has_permission_on [:az_articles], :to => [:show, :index_public]
  end

end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index_user, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy

  privilege :manage_page, :includes => [ :show,
                                         :new,
                                         :new_sub_page,
                                         :attach_snippet,
                                         :create,
                                         :destroy,
                                         :destroy_bp,
                                         #:add_block,
                                         #:remove_block,
                                         :attach_component_page, :remove_component_page,
                                         :destroy_lnk,
                                         #:copy,
                                         :page_box_content,
                                         :update_types,
                                         :update,
                                         :update_description_and_title,
                                         :set_design_source,
                                         :set_functionality_source,
                                         :designs_tooltip,
                                         :edit_page,
                                         :change_page_parent, :add_page_parent,
                                         :move_up,
                                         :move_down,
                                         :move_tr_up,
                                         :move_tr_down,
                                         :add_data_type,
                                         :remove_data_type,
                                         :description_dialog,
                                         :description_wo_title_dialog,
                                         :tr_description_tooltip,
                                         :tr_description_wo_title_tooltip,
                                         :download_designs_dialog,
                                         :tr_page_position_dialog,
                                         :tr_page_status_dialog,
                                         :update_tr_page_position,
                                         :update_tr_page_status,
                                         :get_page_description,
                                         :page_box, :page_box3,
                                         :page_tr,
                                         :get_page_description1,
                                         :tr_page_status_color
                                         ]


  privilege :manage_projects, :includes => [:create, :delete, :move_up, :move_down]

  privilege :manage_company, :includes => [ :read, :edit, :user_update ]

  privilege :manage_project, :includes => [ :show,
                                            #:show1,
                                            #:show_data, :show_design, :show_blocks, :show_description,
                                            :edit,
                                            :update,
                                            :change_members, # TODO непременимо к блоку!
                                            :show_tr,
                                            :edit_tr,
                                            :show_tr_with_controls,
                                            :show_tr_with_out_controls,
                                            :show_pure_tr, :show_pure_tr_md, :tr_doc,
                                            :change_definitions,
                                            :add_common, :remove_common,
                                            :add_definition, :remove_definition,
                                            :add_component, :remove_component,
                                            :tr_public_pages_content, :tr_admin_pages_content,
                                            :tr_structs_validators_content,
                                            :guest_show,
                                            :data_box,
                                            :expand_panel, :collapse_panel,
                                            #:tr_sort_public_pages, :tr_sort_admin_pages,
                                            #:tr_collapse_admin_pages, :tr_expand_admin_pages,
                                            #:tr_collapse_public_pages, :tr_expand_public_pages,
                                            :show_participants_dialog,
                                            :show_sub_tree, :show_sub_tree2,
                                            :component_list,
                                            :datatype_list,
                                            ]

end


