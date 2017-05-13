module AzPagesHelper
  #--------------------------------------------------------------------------------------------------
  def public_page_description(page)
    page_type = AzPage::Page_user
    #str = ""

#    if page.attached_blocks.size > 0
#      pgs = []
#      page.attached_blocks.each do |block|
#        pgs.concat(block.az_pages.select{|p| p.page_type == page_type})
#      end
#    else
#      pgs = [page]
#    end
#
#    pgs = [page]
#
#    pgs.each do |pg|
#      str += operations_on_page(pg)
#    end

    str = operations_on_page(page)

    #pgs1 = pgs
    #if page.attached_blocks.size > 0
    #  pgs1 << page
    #end

    children = page.get_children(page_type)
    if children.size > 0
     str += "\n"
      if children.size > 1
        str += "Содержит ссылки на следующие страницы: "
        linked_pages = []
        children.each do |child|
          linked_pages << "_" + child.name.downcase + "_"
        end
        str += concatenate_words_with_separators(linked_pages)
      end
      if children.size == 1
       str += "Содержит ссылку на страницу &quot;_#{children[0].name.downcase}_&quot;."
      end
     str += "\n"
    end

    return str
  end
  #--------------------------------------------------------------------------------------------------
#  def operation_on_page(pg)
#    str = ""
#    if pg.az_typed_pages.size > 0
#      str += "<p>"
#      pg.az_typed_pages.each do |tp|
#        tp.az_allowed_operations.each do |aop|
#          template_name = case aop.az_operation.crud_name
#            when 'edit' then
#              '/az_base_projects/tr/operation_edit'
#            when 'new' then
#              '/az_base_projects/tr/operation_new'
#            when 'show' then
#              '/az_base_projects/tr/operation_show'
#            when 'delete' then
#              '/az_base_projects/tr/operation_delete'
#            when 'search' then
#              '/az_base_projects/tr/operation_search'
#            else
#              '/az_base_projects/tr/operation_default'
#          end
#
#          #render :partial => template_name, :locals => {:page => page, :operation => aop.az_operation, :tp => tp }
#
#        end
#      end
#      str += "</p>"
#    end
#  end
  #--------------------------------------------------------------------------------------------------
  def operation_delete(tp)
    str = <<-EOF
      #{random_word(['На странице', 'В этом месте'])} должен быть выведен вопрос \"Вы точно хотите удалить #{tp.az_base_data_type.name.downcase}?\".
      Соотвественно удаление должно произойти если пользователь выберет "Да", при этом #{tp.az_base_data_type.name.downcase}
      должно быть удалено и пользователь возвращен на список #{tp.az_base_data_type.name.downcase}.
      Если пользоватеь нажал "Нет", он должен протсо вернуться к списку #{tp.az_base_data_type.name.downcase}.
    EOF
    str.gsub!(/^ */, '')
    return str
  end
  #--------------------------------------------------------------------------------------------------
  def operation_edit(tp)

    t = nil

    if tp.az_base_data_type.instance_of?(AzStructDataType)
      t = tp.az_base_data_type
    end

    if tp.az_base_data_type.instance_of?(AzCollectionDataType)
      t = tp.az_base_data_type.az_base_data_type
    end

    str = <<-EOF
      На #{random_word(['данной', 'этой'])} странице должа быть возможность #{random_word(['изменить', 'отредактировать'])}
      следующие #{random_word(['данные', 'поля'])} #{tp.az_base_data_type.name.downcase}:
    EOF
      
    str.gsub!(/^ */, '')

    str += variables_list(t)

    s= <<-EOF

      Если введенные данные не корректны или имеются незаполненные обязательные поля,
      #{tp.az_base_data_type.name.downcase}  не должна сохраниться в базе данных.
      При этом должен быть выполнен переход на эту же страницу, с сохранением ранее
      введенных данных и указанием полей которые некорректно заполнены.
    EOF
      
    s.gsub!(/^ */, '')
    str += s

    return str
  end
  #--------------------------------------------------------------------------------------------------
  def operation_new(tp)

    str = ""

    s = <<-EOF
      На #{random_word(['данной', 'этой'])} странице должа быть возможность
      #{random_word(['создать', 'ввести'])} новую запись для #{tp.az_base_data_type.name.downcase}.
      Для ввода должны быть доступны следующие #{random_word(['данные', 'поля'])}:
    EOF

    s.gsub!(/^ */, '')
    str += s

    t = nil

    if tp.az_base_data_type.instance_of?(AzStructDataType)
      t = tp.az_base_data_type
    end

    if tp.az_base_data_type.instance_of?(AzCollectionDataType)
      t = tp.az_base_data_type.az_base_data_type
    end

    #render :partial => '/az_base_projects/tr/variables_list', :locals => {:struct => t}
    str += variables_list(t)

    val_count = 0
    t.az_variables.each do |v|
      val_count += v.az_validators.size
    end

    if val_count > 0

      s = <<-EOF
        Если введенные данные не корректы или имеются незаполненные обязательные поля,
        #{tp.az_base_data_type.name.downcase} не должна создаться исохраниться в базе данных.
        При этом должен быть выполнен переход на эту же страницу, с сохранением ранее
        введенных данных и указанием полей которые некорректно заполнены.
      EOF

      s.gsub!(/^ */, '')
      str += s

    end
    return str
  end
  #--------------------------------------------------------------------------------------------------
  def operation_show(tp)

    str = ""
    t = nil

    if tp.az_base_data_type.instance_of?(AzStructDataType)
      t = tp.az_base_data_type

    s = <<-EOF
      На  #{random_word(['данной', 'этой'])}  странице необходимо  #{random_word(['отобразить', 'показать'])}
      #{tp.az_base_data_type.name.downcase}, причем должны быть #{random_word(['отображены', 'показаны'])}
      следующие #{random_word(['данные', 'поля'])}:
    EOF
      
    s.gsub!(/^ */, '')
    str += s

   #render :partial => '/az_base_projects/tr/variables_list', :locals => {:struct => t}
   str += variables_list(t)

    elsif tp.az_base_data_type.instance_of?(AzCollectionDataType)
      t = tp.az_base_data_type.az_base_data_type
      
      s = <<-EOF
        На #{random_word(['данной', 'этой'])} странице необходимо #{random_word(['отобразить', 'показать'])}
        список #{tp.az_base_data_type.name.downcase}, причем должны быть #{random_word(['отображены', 'показаны'])}
        следующие #{random_word(['столбцы', 'колонки'])}:
      EOF

    s.gsub!(/^ */, '')
    str += s

    #render :partial => '/az_base_projects/tr/variables_list', :locals => {:struct => t}
    str += variables_list(t)

    else
      str += "Произошло что-то странное."

    end

    return str
  end
  #--------------------------------------------------------------------------------------------------
  def operation_new_edit(tp)
    str = ""

    s = <<-EOF
      На #{random_word(['данной', 'этой'])} странице должа быть возможность
      #{random_word(['создать', 'ввести'])} новую запись для #{tp.az_base_data_type.name.downcase}
      или отредактировать существующую.
      Для ввода должны быть доступны следующие #{random_word(['данные', 'поля'])}:
    EOF

    s.gsub!(/^ */, '')
    str += s

    t = nil

    if tp.az_base_data_type.instance_of?(AzStructDataType)
      t = tp.az_base_data_type
    end

    if tp.az_base_data_type.instance_of?(AzCollectionDataType)
      t = tp.az_base_data_type.az_base_data_type
    end

    #render :partial => '/az_base_projects/tr/variables_list', :locals => {:struct => t}
    str += variables_list(t)

    val_count = 0
    t.az_variables.each do |v|
      val_count += v.az_validators.size
    end

    if val_count > 0

      s = <<-EOF
        Если введенные данные не корректы или имеются незаполненные обязательные поля,
        #{tp.az_base_data_type.name.downcase} не должна создаться исохраниться в базе данных.
        При этом должен быть выполнен переход на эту же страницу, с сохранением ранее
        введенных данных и указанием полей которые некорректно заполнены.
      EOF

      s.gsub!(/^ */, '')
      str += s

    end
    return str
  end
  #--------------------------------------------------------------------------------------------------
  def operation_default(tp)

    str = "На странице _#{operation.name}_ _#{tp.az_base_data_type.name.downcase}_.\n"

    t = nil

    if tp.az_base_data_type.instance_of?(AzStructDataType)
      t = tp.az_base_data_type
    end

    if tp.az_base_data_type.instance_of?(AzCollectionDataType)
      t = tp.az_base_data_type.az_base_data_type
    end

    if t != nil
      str += "Должны _#{operation.name}_ следующие данные:"
      str += variables_list(t)
    end

    return str
  end
  #--------------------------------------------------------------------------------------------------
  def operations_on_page(pg)
    str = ""
    s = ''
    
    if pg.az_typed_pages.size > 0
      str += ""
      pg.az_typed_pages.each do |tp|
        op_names = []

        tp.az_allowed_operations.each do |aop|
          op_names << aop.az_operation.crud_name
        end

        if op_names.include?('edit') && op_names.include?('new')
          op_names.delete('edit')
          op_names.delete('new')
          op_names << 'new_edit'
        end

        op_names.each do |op_name|
          case op_name
            when 'edit' then
              s = operation_edit(tp)
            when 'new' then
              s = operation_new(tp)
            when 'new_edit' then
              s = operation_new_edit(tp)
            when 'show' then
              s = operation_show(tp)
            when 'delete' then
              s = operation_delete(tp)
            else
              s = operation_default(tp)
          end
          str += s
        end

      end
    end

    
    

    return str
  end
  #--------------------------------------------------------------------------------------------------
  def variables_list(struct, level = 1, processed_ids = {})

    processed_ids[struct.id] = level

    str = "\n"
    struct.az_variables.each do |variable|
      str += ('*'*level + " " + h(variable.name) + "\n")

      if variable.az_base_data_type.instance_of?(AzStructDataType) && processed_ids[variable.az_base_data_type.id] = nil
        str += variables_list(variable.az_base_data_type level + 1)
      end

      if variable.az_base_data_type.instance_of?(AzCollectionDataType) && processed_ids[variable.az_base_data_type.id] = nil
        str += variables_list(variable.az_base_data_type.az_base_data_type, level + 1)
      end

    end
    
    return str + "\n"
  end
  #--------------------------------------------------------------------------------------------------
  def designs_for_pages(page, pages_d_r)

    str = ""
    pages_d_r.each_pair do |page, pages_r|

      if pages_r.size == 1
        pages_pages = "страницы"
      else
        pages_pages = "страниц"
      end

      if pages_d_r.size == 1
        pages_name = "#{pages_pages}"
      else
        pages_name = "#{pages_pages} "
          if pages_d_r.size > 1
            pages_name += ("_"+ concatenate_words_with_separators(pages_r.collect{|p| p.name.downcase}, ', ', ' и ', '') + "_")
          end
      end

      if page.az_designs.size > 0
        if page.az_designs.size > 1
          str += "Дизайн #{pages_name} находится в файлах: "
        else
          str += "Дизайн #{pages_name} находится в файле: "
        end
        design_sources = []
        page.az_designs.each do |design|
          if page.az_designs.size > 1
            design_description = " (" + design.description + ")"
          else
            design_description = ''
          end
          if design.az_design_source != nil && design.az_design_source.source_file_name != nil
            design_sources << (design.az_design_source.source_file_name + design_description)
          else
            design_sources << ("__________________" + design_description)
          end
        end
        str += concatenate_words_with_separators(design_sources)
      else
        str += "Дизайн #{pages_name} находится в файле: __________________"
      end
      str += "\n"
    end
    return str
  end
end
