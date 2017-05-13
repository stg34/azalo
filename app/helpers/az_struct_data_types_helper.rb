module AzStructDataTypesHelper
#  def back_link_for_data_type1(data_type)
#    back_to_project = ""
#    back_to_component = ""
#    back_to_structs = ""
#    if data_type.az_base_project != nil
#      prj = data_type.az_base_project
#      if prj.class == AzProject
#        back_to_project = (link_to 'Назад к проекту', az_project_path(prj.id)) + '<br/>'
#      elsif prj.class == AzProjectBlock
#        back_to_component = (link_to 'Назад к компоненту', az_project_block_path(prj.id)) + '<br/>'
#      end
#    end
#
#    if data_type.typed_pages.size > 0
#      # TODO тут может быть "назад к " разным компонентам, если одна структура расшарена между ними
#      prj = data_type.typed_pages[0].get_project_over_block
#      if prj.class == AzProject
#        back_to_project = (link_to 'Назад к проекту', az_project_path(prj.id)) + '<br/>'
#      elsif prj.class == AzProjectBlock
#        back_to_component = (link_to 'Назад к компоненту', az_project_block_path(prj.id)) + '<br/>'
#      end
#    end
#    if back_to_project + back_to_component == ''
#      return link_to 'Назад к списку структур', :controller => 'az_struct_data_types', :action => 'index_user'
#    end
#    return back_to_project + back_to_component
#  end


  def back_link_for_data_type(data_type)
    if data_type.az_base_project
      prj = data_type.az_base_project
      s = link_to('Назад', {:controller => prj.class.to_s.tableize, :action => 'show', :id => prj.id, :show_type => 'data'})
    else
      s = link_to('Назад', '/structs')
    end
    return s
  end
end
