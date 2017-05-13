xml.instruct! :xml, :version=>'1.0', :encoding => 'UTF-8', :standalone => 'yes'

if @project.instance_of?(AzProject)
  common_classes_1 = [AzCommonsCommon, AzCommonsPurposeExploitation, AzCommonsPurposeFunctional]
  common_classes_2 = [AzCommonsFunctionality]
  common_classes_3 = [AzCommonsContentCreation, AzCommonsRequirementsHosting, AzCommonsRequirementsReliability, AzCommonsAcceptanceCondition]
else
  common_classes_1 = []
  common_classes_2 = [AzCommonsFunctionality]
  common_classes_3 = [AzCommonsRequirementsHosting]
end

xml <<  ooxml_document do
  ooxml_body do

    body = ''

    ## Название проекта
    body << ooxml_h1 do
      t(:az_label_spec_for) + ' ' + @project.class.get_model_name.downcase + ' "' + h(@project.name) + '"'
    end

    common_classes_1.each do |common_class|

      commons = @project.get_all_commons(common_class.to_s)

      body << ooxml_h2 do
        h(common_class.get_label)
      end

      commons.each do |com|
        body << ooxml_simple_text_paragraph do
          h(com.description)
        end
      end
    end

    body << ooxml_page_break

    body << ooxml_h2 do
      h(t(:az_label_data_types_and_validators))
    end

    datatypes_table_captions = %w(Название Тип Валидаторы Описание)
    @data_types.each do |t|
      body << ooxml_h3 do
        h(t.name)
      end
      body << ooxml_simple_text_paragraph do
        h(t.description)
      end

      body << ooxml_table(t.az_variables.size + 1, 4, 9638) do |row, col|
        variable = t.az_variables[row - 1]
        if row == 0
          datatypes_table_captions[col]
        else
          case col
            when 0
              h(variable.name)
            when 1
              h(variable.az_base_data_type.name)
            when 2
              h(variable.az_validators.collect{|v| v.name}.join(', '))
            when 3
              h(variable.description)
          end
        end
      end

      used_collections = t.collections.select{|c| c.typed_pages.size > 0}

      if used_collections.size > 0
        body << ooxml_h4 do
          t(:az_label_no_data_type_lists)
        end

        used_collections.each do |collection|
          body << ooxml_h5 do
            h(collection.name)
          end

          if collection.description.size > 0
            h(collection.description)
          else
            t(:az_label_no_description)
          end
        end
      end
    end

    body << ooxml_page_break

    body << ooxml_h2 do
      'Публичные страницы'
    end

    @public_pages.each do |page|
      body << render(:partial => '/az_base_projects/tr_edit/page_ooxml.xml.builder', :locals => {:page => page, :image_list => image_list})
    end

    body << ooxml_page_break
    #ooxml_picture(xml, nil, 1)

    #ooxml_page_break
    #ooxml_picture(xml, nil, 2)



    body << ooxml_simple_text_paragraph do
      'Hello world 2'
    end

    body << ooxml_textile_text do
      #'ПРИВЕТ *ЖИРНОТА* _НАКЛОНОТА_ _*ЖИРНОТА НАКЛОНОТА*_ ПОКА +ПОДЧЕРКИВАНИЕ+ -зачеркивание- 2 ^2^ log ~10~ I am <pre>very</pre> serious. @Inline Code@ '
      'I am <pre>very</pre> serious. @Inline Code@ 4 x 4 = 16'
    end


    body << ooxml_textile_text do
      '<pre>fafa
      kuku</pre>'
    end

    body << ooxml_sect_pr
  end

end





