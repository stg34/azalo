class ActivityObserver < ActiveRecord::Observer

  defaults = {:after_create_method => :after_create_common,
              :before_update_method => :before_update_common,
              :after_update_method => :after_update_common,
              :before_destroy_method => :before_destroy_common,
              :after_destroy_method => :after_destroy_common,
              :name_field => :name
              }

  @@models = {}
  

  @@models[AzPage] = {:fields => [:name, :page_type, :description, :title, :parent_id, :status, :az_design_double_page_id],
                      :project_field => :get_project_over_block}
  @@models[AzPage].merge!(defaults)


  @@models[AzDefinition] = {:fields => [:name, :definition, :status],
                            :project_field => :az_base_project}
  @@models[AzDefinition].merge!(defaults)


  @@models[AzValidator] = {:fields => [:name, :description, :condition, :message],
                           :project_field => :get_project}
  @@models[AzValidator].merge!(defaults)


  @@models[AzVariable] = {:fields => [:name, :description, :az_base_data_type_id],
                          :project_field => :get_project}
  @@models[AzVariable].merge!(defaults)


  @@models[AzStructDataType] = {:fields => [:name, :description, :status],
                                :project_field => :get_project}
  @@models[AzStructDataType].merge!(defaults)


  @@models[AzCollectionDataType] = {:fields => [:name, :az_collection_template_id],
                                    :project_field => :get_project}
  @@models[AzCollectionDataType].merge!(defaults)


  @@models[AzDesign] = {:fields => [:description],
                        :project_field => :get_project_over_block}
  @@models[AzDesign].merge!(defaults)
  @@models[AzDesign].merge!({:name_field => :description})


  @@models[AzProjectBlock] = {:fields => [:name],
                              :project_field => :parent_project}
  @@models[AzProjectBlock].merge!(defaults)


  @@models[AzProject] = {:fields => [:name, :favicon_file_name, :layout_time, :az_project_status_id, :public_access],
                         :project_field => :get_self}
  @@models[AzProject].merge!(defaults)


#  @@models[AzImage] = {:after_create_method => nil,
#                       :before_update_method => :before_update_image,
#                       :after_update_method => :after_update_image,
#                       :before_destroy_method => nil,
#                       :after_destroy_method => nil,
#                       :name_field => :name,
#                       :fields => [:image_file_name, :az_design_id],
#                       :project_field => nil}
  
  common = {:after_create_method => :after_create_common,
            :before_update_method => :before_update_common,
            :after_update_method => :after_update_common,
            :fields => [:name, :description, :comment, :status],
            :name_field => :name,
            :project_field => :az_base_project
            }

  @@models[AzCommonsAcceptanceCondition] = common
  @@models[AzCommonsCommon] = common
  @@models[AzCommonsContentCreation] = common
  @@models[AzCommonsPurposeExploitation] = common
  @@models[AzCommonsPurposeFunctional] = common
  @@models[AzCommonsRequirementsHosting] = common
  @@models[AzCommonsRequirementsReliability] = common

  models = @@models.collect{|k, v| k}

  #observe([])
  observe(models)

  def after_create(model)
    #return
    m = @@models[model.class]
    if !m
      return
    end
    if m[:after_create_method]
      send(m[:after_create_method], model)
    end
  end

  def before_update(model)
    m = @@models[model.class]
    if !m
      return
    end
    if m[:before_update_method]
      send(m[:before_update_method], model)
    end
  end

  def after_update(model)
    m = @@models[model.class]
    if !m
      return
    end
    if m[:after_update_method]
      send(m[:after_update_method], model)
    end
  end

  def before_destroy(model)
    return
    m = @@models[model.class]
    if !m
      return
    end
    if m[:before_destroy_method]
      send(m[:before_destroy_method], model)
    end
  end

  def after_destroy(model)
    return
    m = @@models[model.class]
    if !m
      return
    end
    if m[:after_destroy_method]
      send(m[:after_destroy_method], model)
    end
  end

  private
 
  def before_update_common(model)
    @@old_values = {}
    #old_model = model.class.find(model.id)
    old_model = model.class.find(:first, :conditions => {:id => model.id})
    if old_model
      @@models[model.class][:fields].each do |f|
        if old_model[f] != model[f]
          @@old_values[f] = old_model[f]
        end
      end
    end
  end

  def after_update_common(model)
    if @@old_values.size == 0
      return
    end

    activity = AzActivity.new

    if Authorization.current_user != nil
      activity.user_id = Authorization.current_user.id
    else
      activity.user_id = -1
    end

    project_field = @@models[model.class][:project_field]
    prj = eval("model.#{project_field}")
    if prj
      activity.project_id = prj.id
    else
      activity.project_id = nil
    end
    activity.owner_id = model.owner.id
    activity.model_name = model.class.to_s
    activity.object_name = model[@@models[model.class][:name_field]]
    activity.model_id = model.id
    activity.action = 'u'

    @@old_values.each_pair do |field, value|
      activity_field = AzActivityField.new
      activity_field.field = field.to_s
      activity_field.old_value = value
      activity_field.new_value = model[field]
      activity.az_activity_fields << activity_field
    end

    activity.save!
  end
  
  
  def after_create_common(model)
    model = model.class.find(:first, :conditions => {:id => model.id})
    activity = AzActivity.new

    if Authorization.current_user != nil
      activity.user_id = Authorization.current_user.id
    else
      activity.user_id = -1
    end

    #p caller
    #puts caller.class
    caller.each do |c|
      if c.include?("make_copy")
        return
      end
    end

    project_field = @@models[model.class][:project_field]
    activity.project_id = ActivityObserver.get_project_id(model, project_field)
    activity.owner_id = model.owner.id
    activity.model_name = model.class.to_s
    activity.object_name = model[@@models[model.class][:name_field]]
    activity.model_id = model.id
    activity.action = 'c'
    activity.save!
  end


  def before_destroy_common(model)
    @@old_values = {}
    old_model = model #model.class.find(model.id)
    if old_model
      @@old_values[:name] = model[@@models[model.class][:name_field]]
    end
  end

  def after_destroy_common(model)
    if @@old_values.size == 0
      return
    end

    activity = AzActivity.new

    if Authorization.current_user != nil
      activity.user_id = Authorization.current_user.id
    else
      activity.user_id = -1
    end

    project_field = @@models[model.class][:project_field]
    #puts "##############################################################################"
    #puts project_field.to_s
    #puts "##############################################################################"

    prj = eval("model.#{project_field}")
    if prj
      activity.project_id = prj.id
    else
      activity.project_id = nil
    end
    #activity.project_id = model[project_field].id
    activity.owner_id = model.owner.id
    activity.model_name = model.class.to_s
    activity.object_name = @@old_values[:name]
    activity.model_id = model.id
    activity.action = 'd'
    activity.save!
  end

  def self.get_project_id(model, project_field)
    prj = eval("model.#{project_field}")
    if prj
      return prj.id
    end
    return nil
  end

  def before_update_image(model)
    #puts "before_update_image ##############################################################################"
    #puts "#{Authorization.current_user} #{page.name}"
    #puts "##############################################################################"
    @@old_values = {}
    old_model = model.class.find(:first, :conditions => {:id => model.id})
    if old_model
      @@models[model.class][:fields].each do |f|
        if old_model[f] != model[f]
          @@old_values[f] = old_model[f]
        end
      end
    end
  end

  def after_update_image(model)
    #puts "after_update_image ##############################################################################"
    if @@old_values.size == 0
      return
    end

    activity = AzActivity.new

    if Authorization.current_user != nil
      activity.user_id = Authorization.current_user.id
    else
      activity.user_id = -1
    end

    project_field = @@models[model.class][:project_field]
    #puts "##############################################################################"
    #puts project_field.to_s
    #puts "##############################################################################"

    prj = model.az_design.az_page.get_project_over_block
    activity.project_id = prj.id
    
    #activity.project_id = model[project_field].id
    #puts "1-------------------------------------------------------------------------------"
    if model.az_design == nil
      return
    end
    #puts "2-------------------------------------------------------------------------------"
    activity.owner_id = model.az_design.id
    activity.model_name = model.class.to_s
    activity.object_name = 'Изображение'
    activity.model_id = model.id
    activity.action = 'u'

    @@old_values.each_pair do |field, value|
      activity_field = AzActivityField.new
      activity_field.field = field.to_s
      activity_field.old_value = value
      activity_field.new_value = model[field]
      activity.az_activity_fields << activity_field
    end

    activity.save!
  end
end
