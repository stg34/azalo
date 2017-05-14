# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def page_design_sources(page)
    str = ""
    designs_count = page.get_all_designs_count
    designs = page.get_all_designs
    uploaded_design_sources_count = page.get_uploaded_design_sources_count
    title = 'Скачать исходники дизайна'
    if designs_count > 0
      on_click_str = "show_download_designs_dialog('#{page.id}'); return false;"

      if designs_count == 1 && uploaded_design_sources_count == designs_count
        str += link_to(image_tag("download-silver.png", :class => "floppy", :title=>title), designs[0].az_design_source.source.url)
      else
        floppy = "download-red.png"
        if uploaded_design_sources_count == designs_count
          floppy = "download-silver.png"
        elsif uploaded_design_sources_count == 0
          floppy = "download-red.png"
        else
          floppy = "download-yellow.png"
        end
        str += link_to(image_tag(floppy, :class => "floppy", :title=>title), "#", :onclick => on_click_str)
      end

    end
    return str
  end

  def page_box_images(page)
    az_page_image_tag(page) + aligner_tag + page_design_sources(page) + aligner_tag
  end

  def az_page_image_tag(page)
    id = page.id
    head_az_image = page.get_main_design.get_head_az_image

    if !page.has_designs_without_images
      background_image_url = head_az_image.image.url(:tiny)
    end

    w = Integer(head_az_image.tiny_image_width)
    h = Integer(head_az_image.tiny_image_height)
    img = image_tag(head_az_image.image.url(:tiny), "id"=>"pg_" + id.to_s, :width => w, :height => h, :class=> "box_tiny_image")

    link_id = "show-designs-dialog-link-#{id}"
    a = link_to(img, "#", :id => link_id, :class => 'box_tiny_image_link', :onclick => "show_designs_dialog('#{page.id}'); return false;")
    scr = ''
    holder_delta_w = 0
    
    if page.get_all_designs.size > 1
      
      if !page.has_designs_without_images
        background_image = "background: url(#{head_az_image.image.url(:tiny)})"
      end

      div_bg_1 = "<div class=\"tiny_image_bg_1\" style=\"width: #{w-2}px; height: #{h-2}px; #{background_image}\"></div>"
      div_bg_2 = "<div class=\"tiny_image_bg_2\" style=\"width: #{w-2}px; height: #{h-2}px; #{background_image}\"></div>"

      link = "<div style=\"background: url(#{background_image_url}); background-repeat: no-repeat; background-position: 6px 6px; padding-bottom: 3px; padding-right: 6px;\">" +
      "<div style=\"background: url(#{background_image_url}); background-repeat: no-repeat; background-position: 3px 3px; padding-bottom: 6px; padding-right: 3px;\">" +
      "#{a}" +
      "</div>" +
      "</div>"
      link = div_bg_2 + div_bg_1 + a;
      holder_delta_w = 6
    else
      link = a;
    end

    dnd_anchor = ""
    remove_double = ""
    if page.design_source == nil
      dnd_anchor = @template.content_tag('div', "", :class => 'draggable-design-source', :title=>'Тяни-бросай этот дизайн на другую страницу');
    else
      title = "Убрать дублирование дизайна страницы '#{page.design_source.name}'"
      onclick = "set_page_design_source('', #{page.id}); return false;"
      remove_double_button = @template.content_tag('input', '', :value => 'X', :type => 'submit', :class => 'remove-design-source', :title => title, :onclick => onclick)
      remove_double = @template.content_tag('div', remove_double_button, :class => 'remove-design-source-holder');
    end

    str = "<div class='box_tiny_image_holder' style='width: #{w + holder_delta_w}px; height: #{h + 6}px'>" + link + scr + '</div>' + aligner_tag
    return remove_double + dnd_anchor + str
  end

  def design_image_tag(design, size, show_tooltip = true)

    page = design.page
    id = page.id
    did = design.id
    page_info = "<div>#{page.name}</div>"
    js = "<script>var pg_tooltip_#{id} = new Tooltip('pg_#{id}_#{did}', 'tooltip_#{id}_#{did}')</script>"

    image = design
    img = image_tag image.image.url(size), "id"=>"pg_" + id.to_s + "_" + did.to_s
    a = link_to(img, image.image.url)
    tooltip_img = image_tag image.image.url(:medium)

    tooltip = '<div class="tooltip" id="tooltip_' + id.to_s + "_" + did.to_s + '">' + page_info + tooltip_img + '</div>'
    if show_tooltip
      return a + tooltip + js;
    else
      return a;
    end
  end

  def project_favicon_tag(project)
    if project.favicon_file_size == nil || project.favicon_file_size < 1
      return image_tag "no_image_16x16.gif"
    else
      return image_tag project.favicon.url
    end
  end

  def dfn(a)
    return '<dfn>' + a + '</dfn>'
  end

  def dfn_c(a)
    return '<dfn class="capitalize">' + a + '</dfn>'
  end

  def boolean_to_img(b, size = :medium)
    if b
      return img_plus(size)
    else
      return img_minus(size)
    end
  end

  def img_go_up
      return '<img class="ud-down-arrows" src="/images/go_up.png">'
  end

  def img_go_down
      return '<img class="ud-down-arrows" src="/images/go_down.png">'
  end

  def img_plus(size = :medium)
    case size
      when :small
        return '<img src="/images/plus_small.png">'
      when :medium
        return '<img src="/images/plus.png">'
      when :large
        return '<img src="/images/plus.png">'
    end
    return '<img src="/images/plus.png">'
  end

  def img_minus(size = :medium)
      case size
      when :small
        return '<img src="/images/minus_small.png">'
      when :medium
        return '<img src="/images/minus.png">'
      when :large
        return '<img src="/images/minus.png">'
    end
    return '<img src="/images/minus.png">'
  end

  def img_new
      return '<img src="/images/new.png">'
  end

  def img_edit
      return '<img src="/images/edit.png">'
  end

  def img_delete
      return '<img src="/images/delete.png">'
  end

  def boolean_to_yes(b)
    if b
      return 'Да'
    else
      return ''
    end
  end

  def getShowLabel
    return 'Показать'
  end

  def getHideLabel
    return t(:az_label_hide)
  end

  def switchShowHideLabels(id, show_label = nil, hide_label = nil)

    if show_label == nil
      show_label = getShowLabel
    end

    if hide_label == nil
      hide_label = getHideLabel
    end

    str = <<-EOF
      element = document.getElementById("#{id}");
      if (element.innerHTML.search("#{hide_label}") >= 0)
      {
        element.innerHTML = element.innerHTML.replace("#{hide_label}","#{show_label}");
      }
      else
      {
        element.innerHTML = element.innerHTML.replace("#{show_label}","#{hide_label}");
      }
    EOF
    return str
  end

  
  def aligner_tag
    return '<div class="aligner"></div>'
  end

  def percent_complete1(page)
    str = <<-EOF
      <a href="#" onclick="show_page_tasks_dialog('#{page.id}'); return false;">Задачи</a>
    EOF
    return str
  end

  def unassigned_issues_percent_complete(project, task_types)
    all_issues, issues = project.get_unassigned_issues(task_types)
    return percent_complete_2(issues, all_issues, -1, project.id)
  end

  def percent_complete_2(issues, all_issues, page_id, project_id)
    tasks_time = 0
    tasks_time_done = 0
    done_ratio = 0
    issues.each do |issue|
      estimated_hours = (issue['estimated_hours'] == nil ? 0 : Float(issue['estimated_hours']))
      tasks_time += estimated_hours
      done_ratio += Float(issue['done_ratio'])
      tasks_time_done += estimated_hours * (Float(issue['done_ratio'])/100.0)
    end

    
    if tasks_time == 0
      dev = done_ratio
    else
      dev = tasks_time_done * 100.0 / tasks_time;
    end
  
    bar_width = 100.0;
    bar_padding = 2;
    
    pos = (dev)*(bar_width + bar_padding + bar_padding)/100

    if issues.size == 0
      pos = 0
    end
    
    shadow_style = " behavior: url(/stylesheets/pie.htc);" +
                   " text-shadow: 0 0 1px white;"

    radius_style = " behavior: url(/stylesheets/pie.htc); " +
                   " -moz-border-radius: 3px;" +
                   " -webkit-border-radius: 3px; " +
                   " -khtml-border-radius: 3px; " +
                   " border-radius: 3px; "

    style = 
      
      " width: #{bar_width}px; " +
      " background: #95B7D5 url(/images/progress_gray.png) repeat-y;" +
      " background-position: #{pos}px; " + 
      " text-align: center; " +
      " font-size: 10px; color: #555555;" +
      " float: left;" +
      " padding: #{bar_padding}px;" +
      " border:1px solid gray;" +
      shadow_style +
      radius_style
    
      if issues.size > 0
        style += "cursor: pointer; text-decoration: underline"
        if page_id > 0
          str = "<div style='#{style}' onclick='show_page_tasks_dialog(\"#{page_id}\"); return false;'>" + sprintf("%.1f", dev) + '%</div>' + "\n"
        else
          str = "<div style='#{style}' onclick='show_unassigned_tasks_dialog(\"#{project_id}\"); return false;'>" + sprintf("%.1f", dev) + '%</div>' + "\n"
        end
      else
        style += "background-color: #e1d9d0; "
        style += "background-image: none; "

        permitted_to_edit = false
        permitted_to? :edit do
          permitted_to_edit = true
        end

        if permitted_to_edit
          style += "cursor: pointer; text-decoration: underline"
          if page_id > 0
            if all_issues.size > 0
              str = "<div style='#{style}' title='Нет задач, удовлетворяющих фильтру' onclick='show_page_tasks_dialog(\"#{page_id}\"); return false;'>Нет задач*</div>\n"
            else
              str = "<div style='#{style}' onclick='show_new_page_tasks_dialog(\"#{page_id}\"); return false;'>Создать задачи</div>\n"
            end
          else
            if all_issues.size > 0
              str = "<div style='#{style}' title='Нет задач, удовлетворяющих фильтру' onclick='show_project_tasks_dialog(\"#{project_id}\"); return false;'>Нет задач*</div>\n"
            else
              str = "<div style='#{style}' onclick='show_new_project_tasks_dialog(\"#{project_id}\"); return false;'>Создать задачи</div>\n"
            end
          end
        else
          str = "<div style='#{style}'>Нет задач</div>\n"
        end

      end

      return str
  end

  def progress_bar(percent, bar_width = 300, bar_height = 24, border_radius = 7)
    pos = Integer(percent)*bar_width/100.0;

    bar_width = bar_width.to_s + "px"
    bar_height = bar_height.to_s + "px"
    border_radius = border_radius.to_s + "px"

    if is_browser_ie && false
      radius_style = ""
    else
      radius_style = " -moz-border-radius: #{border_radius}; " +
                   " -webkit-border-radius: #{border_radius}; " +
                   " -khtml-border-radius: #{border_radius}; " +
                   " border-radius: #{border_radius}; " +
                   " behavior: url(/stylesheets/pie.htc);"
    end

    '<div style="' +
    'border:1px solid gray; ' +
    "width: #{bar_width};" +
    
    "height:#{bar_height};" +
    "background: #728FA8 url(/images/progress_gray.png) no-repeat #{pos}px 0; " +
    radius_style + 
    'text-align: center;">' +
    
    '</div>'
  end


  def progress_bar_wo_radius_for_ie(percent, bar_width = 300, bar_height = 24, border_radius = 7)
    pos = Integer(percent)*bar_width/100.0;

    bar_width = bar_width.to_s + "px"
    bar_height = bar_height.to_s + "px"
    border_radius = border_radius.to_s + "px"

    if is_browser_ie
      radius_style = ""
    else
      radius_style = " -moz-border-radius: #{border_radius}; " +
                   " -webkit-border-radius: #{border_radius}; " +
                   " -khtml-border-radius: #{border_radius}; " +
                   " border-radius: #{border_radius}; "
    end

    '<div style="' +
    'border:1px solid gray; ' +
    "width: #{bar_width};" +

    "height:#{bar_height};" +
    "background: #728FA8 url(/images/progress_gray.png) no-repeat #{pos}px 0; " +
    radius_style +
    'text-align: center;">' +

    '</div>'

    # #95B7D5
  end

  def block_page_popup_menu_tag(page)

    id = page.id
    a = "<a href='#' id='page_popup_#{id}'>Редактировать</a>"

    page_menu = "<div class='controls' style='display: none;' id='page_popup_content_#{id}'>" +
      link_to("Нов. стр.", :controller => "az_pages", :action => "new_sub_page", :az_page_id=>page.id) + '<br/>' +
      link_to( "Показать", page) + '<br/>' +
      link_to("Ред.", edit_az_page_path(page)) + '<br/>' +
      link_to("Удалить", page, :confirm => "Точно?", :method => :delete) + '<br/>' +
    '</div>'

    tooltip = "<script type='text/javascript'>TooltipManager.addHTML('page_popup_#{id}', 'page_popup_content_#{id}')</script>"
    return a + page_menu + tooltip;
  end

  def page_snippets_menu_tag(page, snippets)

    id = page.id
    a_snippets = "<a href='#' id='snippets_popup_#{id}'>Добавить кусочек</a>"
    snippet_links = ""
    snippets.each do |snippet|
      snippet_links += link_to('1Добавить кусочек "' + snippet.name + '"', :controller => "az_pages", :id=>id, :az_snippet_id => snippet.id, :action => "attach_snippet") + '<br/>'
    end

    snippets_menu = "<div class='controls' style='display: none;' id='snippets_popup_content_#{id}'>" +
      snippet_links + '</div>'
    snippets_tooltip = "<script type='text/javascript'>TooltipManager.addHTML('snippets_popup_#{id}', 'snippets_popup_content_#{id}')</script>"

    return a_snippets + snippets_menu + snippets_tooltip;
  end

  def var_type_tag(var, level = 0, ids = [])
    #str = var.name + "<small>(" + var.class.name + "(" + var.id.to_s + "))</small>:" + var.az_base_data_type.name + "<small>(" + var.az_base_data_type.class.name + ")</small><br/>"
    str = var.name + ":" + var.az_base_data_type.name + "<br/>"
    ids << var.id
    if var.az_base_data_type.instance_of?(AzStructDataType)
      var.az_base_data_type.az_variables.each do |v|
        str += var_type_tag(v)
      end
    end

    if var.az_base_data_type.instance_of?(AzCollectionDataType)
      collection_data_type = var.az_base_data_type.az_base_data_type
      if collection_data_type.instance_of?(AzStructDataType)
        str += "<b>" + collection_data_type.name + "</b><br/>"
        collection_data_type.az_variables.each do |v|
          if !ids.include?(v.id)
            str += var_type_tag(v, level+1, ids)
          end
        end
      end
    end

    return str
  end

  def page_data_types_tag(page)
    str = ""
    page.types.each do |type|
      if type.instance_of?(AzStructDataType)
          type.az_variables.each do |var|
          str += var_type_tag(var)
        end
      end
      if type.instance_of?(AzCollectionDataType)
        str += type.az_collection_template.name + ' из ' + type.az_base_data_type.name + '<br/>'
      end
    end
    return str
  end

  def page_types_with_operations(page, project, show_delete_button = true)

    str =''

    if page.az_typed_pages.size == 0
      return '<div style="display: block">' + render(:partial => "helpers/block_page_form", :locals=>{:page => page, :project => project, :data_type_id => nil}) + '</div>'
    end

    az_typed_page_num = 0

    page.az_typed_pages.each do |tp|

      form_str = ""
      if show_delete_button
        form_str = render(:partial => "helpers/block_page_form", :locals=>{:page => page, :project => project, :data_type_id => tp.az_base_data_type.id})
      end

      str += "<table class='table' style='width: 100%;'>" +
        "<tr><th id='pg_#{tp.id}'><a href='#' onclick='show_operations_edit_dialog(#{tp.id}); return false;'>#{tp.az_base_data_type.name}</a></th>" +
        "<th>#{form_str}</th></tr>"
    
      tp.az_allowed_operations.each do |aop|
        str += "<tr><td colspan='2'>#{aop.az_operation.name}</td></tr>"
      end
      
      str += "<tr><td>Сложность</td><td>#{tp.get_time_for_operations.to_s}</td></tr></table>"
      #str += block_page_popup_tag(tp)

      if az_typed_page_num + 1 < page.az_typed_pages.size && page.az_typed_pages.size > 1
        str += '<div style="height: 2px;"></div>'
      end

      az_typed_page_num += 1

    end

    return str 
  end

  def page_components(page)
    if page.root
      return ""
    end
    str = "<table style='width:100%'>"

    page.get_embedded_pages1.each_with_index do |embedded_page, i|
      td_class = ""
      if i == page.get_embedded_pages1.size - 1
        td_class = "last"
      end
      str += "<tr style='width:100%'>"
      str += "<td class='#{td_class}'>#{embedded_page.name}</td>"
      str += "<td style='width: 1px;' class='#{td_class}'>"
      str += submit_tag("X", :onclick => "remove_component_page_from_page(#{page.id}, #{embedded_page.id});", :class=>'remove-component-page')
      str += "</td>"
      str += "</tr>"
    end

    str += "</table>"
    str = @template.content_tag('div', str, :class => 'page-box-components')
    return str
  end

#  def page_types(page)
#    # TODO устаревшая функция
#
#    str ="#{page.id}<br/>"
#    str = page.parents.collect{|p| p.id}.join('')
#    str += "<br/> #{page.embedded}"
#
#    types_num = 0
#
#    page.get_embedded_pages1.each do |embedded_page|
#      str += "#{embedded_page.id}<br/>"
#      #block = embedded_page.az_base_project
#      #str += link_to(block.name, az_project_block_path(block))
#      #str += " "
#      #str += link_to("X", "/az_pages/remove_block/#{page.id}/#{block.id}", :methot => :post)
#      str += "<br/>"
#
#
#      permitted_to?(:edit) do
#        str += "<div class='page-anchor' id='anchor-#{embedded_page.id}'>"
#          str += image_tag('anchor.png', :alt => 'Изменить родительскую страницу. Тяни-бросай на другую страницу', :title => 'Изменить родительскую страницу. Тяни-бросай на другую страницу')
#          str += "<div style='display: none;' class='anchor-page-id'>"
#            str += embedded_page.id.to_s
#          str += "</div>"
#        str += "</div>"
#        str += "<div class='page-anchor' id='anchors-#{embedded_page.id}'>"
#          str += image_tag('anchors.png', :alt => 'Изменить родительскую страницу. Тяни-бросай на другую страницу', :title => 'Изменить родительскую страницу. Тяни-бросай на другую страницу')
#          str += "<div style='display: none;' class='anchor-page-id'>"
#            str += embedded_page.id.to_s
#          str += "</div>"
#        str += "</div>"
#        str += "<script type='text/javascript'>"
#          str += "add_draggables(#{embedded_page.id});"
#        str += "</script>"
#      end
#
#
#    end
#
#    if (page.az_typed_pages.size + types_num) == 0
#      str += ''
#    end
#
#    str = @template.content_tag('div', str, :class => 'page-box-components')
#    return str
#  end


  def page_types1(page)

    str =''

    types_num = 0

    page.attached_blocks.each do |block|
      block.az_pages.each do |pg|
        if pg.page_type == AzPage::Page_user
          pg.az_typed_pages.each do |tp|
            types_num += 1
            str += "<table class='table' style='width: 100%;'>" +
            "<tr>" +
            "<th><span class='tooltiped'>" +
            "#{tp.az_base_data_type.name}" +
            "</span></th>" +
            "</tr>"
            tp.az_allowed_operations.each do |aop|
              str += "<tr><td>"
              str += aop.az_operation.name
              str += "</td></tr>"
            end
            str += "</table>"
          end
        end
      end
    end

    if (page.az_typed_pages.size + types_num) == 0
      str += 'Нет<br/>данных'
    end

    page.az_typed_pages.each do |tp|
      str += "<table class='table' style='width: 100%;'>" +
        "<tr>" +
          "<th id='pg_#{tp.id}'><span class='data-type'>" +
            "#{tp.az_base_data_type.name}" +
          "</span></th>" +
        "</tr>"
      tp.az_allowed_operations.each do |aop|
        str += "<tr><td>"
        str += aop.az_operation.name
        str += "</td></tr>"
      end
      str += "</table>"
    end


    return str
  end

  def page_box_min_size
    min_width = '<div class="page_box_min_width"></div>'
    min_height = '<div  class="page_box_min_height"></div>'
    return min_height + min_width
  end

  def page_description_tooltip(page, element_id, show_title = true)
    tooltip = ""
    tooltip += "<script type='text/javascript'>"
    if show_title
      tooltip += "TooltipManager.addAjax('#{element_id}', {url: '" + url_for(:controller=>'az_pages', :action=>'description_tooltip', :id=>page.id) + "', options: {method: 'get'}});"
    else
      tooltip += "TooltipManager.addAjax('#{element_id}', {url: '" + url_for(:controller=>'az_pages', :action=>'description_wo_title_tooltip', :id=>page.id) + "', options: {method: 'get'}});"
    end
    tooltip += "</script>"
    return tooltip
  end

  def cut_string(str, len)
    ellipsis = '...'
    if str != nil && str.mb_chars.size > len
      return str.mb_chars[0..(len - 1 - ellipsis.mb_chars.size)] + ellipsis
    else
      return str
    end
  end
  def page_description_content_tag(page, project)
    #TODO устаревшая, заменить на page_box_descriptions
    return page_box_descriptions(page, project)
  end

  def page_box_descriptions(page, project)
    
    #str += page_box_min_size
    #str += "<div id='page-td-#{page.id}' style='cursor: pointer;' onclick='#{on_click_str}'>"

    on_click_str = "show_description_dialog('#{page.id}'); return false;"
    str_b = ""
    str = <<-EOF
      #{page_box_min_size}
      <div id='page-td-#{page.id}' style='cursor: pointer;' onclick="#{on_click_str}">
      <div class='title'> #{h(cut_string(page.title, 25))} &nbsp;</div>
      <div class='description'> #{page_box_min_size} #{RedCloth.new(n2e cut_string(page.description, 100)).to_html} #{aligner_tag} </div>
      </div>
    EOF
    pages = page.get_embedded_pages1
    pages = pages.select { |p| p.page_type == AzPage::Page_user }
    pages.each do |pg|
      on_click_str = "show_description_dialog_wo_title('#{pg.id}', '#{page.id}');"
      str1 = <<-EOF
        <hr/>
        <div id='page-td-#{pg.id}' style='cursor: pointer;' onclick="#{on_click_str}">
        <div class='description'> #{page_box_min_size} #{RedCloth.new(n2e cut_string(pg.description, 100)).to_html} #{aligner_tag} </div>
        </div>
      EOF
      str_b += str1
    end
    return str + str_b
  end

  def page_element_id(parent_id, page_num)
    return parent_id.to_s + "_" + page_num.to_s
  end

  def page_box_data(page, project, update_types)
    if update_types == true
      project = page.get_project_over_block
    end

    str = ""
    str += page_box_min_size
    str += page_types_with_operations(page, project)

#    if page.attached_blocks.size > 0
#      page.attached_blocks.each do |block|
#        pages = block.az_pages.select {|pg| pg.is_embedded && pg.page_type == AzPage::Page_user}
#        pages.each do |pg|
#          str += '<div style="height: 2px;"></div>'
#          str += page_types_with_operations(pg, project, false)
#        end
#      end
#    end

    str += aligner_tag
    return str
  end

#  def page_data_content_tag(page)
#    return page_box_min_size + page_types(page)
#  end

  def page_box_components(page)
    return page_box_min_size + page_components(page)
  end

  def page_components_content_tag(page)
    #TODO устаревшая, заменить на page_box_components
    return page_box_components(page)
  end


#  def az_data_type_info_tooltip(data_type, element_id)
#    tooltip = ""
#    if data_type.instance_of?(AzStructDataType)
#      tooltip = "<script type='text/javascript'>" +
#      "TooltipManager.addAjax('#{element_id}', {url: '" + url_for(:controller=>'az_struct_data_types', :action=>'info_tooltip', :id=>data_type.id) + "', options: {method: 'get'}}, -200, 0);" +
#      "</script>"
#    end
#    return tooltip
#  end

  def random_word(words)
    return  words[Integer(rand()*words.size)]
  end

  def concatenate_words_with_separators(words, comma = ', ', and_ = ' и ', point = '.')
    m = 0
    words_size = words.size
    c_words = ''
    words.each do |word|
      c_words << word
      c_words << comma if m + 2 < words_size
      c_words << point if m + 1 == words_size
      c_words << and_ if m + 2 == words_size
      m += 1
    end
    return c_words
  end

  def n2e(str)
    if str == nil
      return ''
    end
    return str
  end

  def wiki_syntax_help
    %q[<a onclick="window.open('/help/wiki_syntax.html', '', 'resizable=yes, location=no, width=300, height=640, menubar=no, status=no, scrollbars=yes'); return false;" href="/help/wiki_syntax.html">Помощь по синтаксису</a>]
  end

  def required_field
    return ' * '
  end

  def crumbs(data)
    return render(:partial => "helpers/crumbs", :locals=>{:crumbs => data})
  end

  def tooltip_image(id, content_id)
    return '<img class="help-image" src="/images/help.gif" id="' + id + '" alt="help"/> <script>TooltipManager.addHTML("'+ id +'", "' + content_id + '");</script>'
  end


  def t_b
    return '<table><tr><td>'
  end

  def t_e(id, content_id)
    return '</td><td>' + tooltip_image(id, content_id) + '</td></tr></table>'
  end

  def is_browser_ie
    begin
      if browser_name != nil
        if browser_name && (browser_name.index(/^ie/) == 0)
          return 6
        end
      end
    rescue
      return false
    end
    return false
  end

  def items_and_seeds(items, seeds)
    items = items
    
    p_ids = items.collect{|p| p.copy_of }
    p_ids.compact!
    seeds.delete_if{|k, v| p_ids.include?(k) }

    str = '<table class="table" style="margin: 2px;">'

    items.each do |item|
      str += '<tr>'
      str += '<td>'
      str += "<b>" if item.seed
      str += link_to item.name, item
      str += "<b>" if item.seed 
      str += '</td>'
      str += '<td>'
      str += "Обн." if item.matrix && item.matrix.seed
      str += '</td>'
      str += '</tr>'
    end

    seeds.each_value do |item|
      str += '<tr>'
      str += '<td>'
      str += '<span style="color: silver">'
      str += item.name
      str += '</span>'
      str += "</td>"
      str += '<td>'
      str += 'Коп.'
      str += '</td>'
      str += '</tr>'
    end

    str += '</table>'
  end

  def submit_and_disable_tag(form, value = "Save changes", options = {})

    id = "sbmt-" + Integer(rand()*999999999).to_s
    b1 = form.submit(value, options.reverse_merge(:onclick => "$(this).hide(); $('#{id}').show();") )
    b2 = form.submit("     ", :id => id, :disabled => true, :class=> "disabled-input", :style=> "display: none;" )

    return b1 + b2
  end

  def submit_and_disable_tag2(value = "Save changes", options = {})

    id = "sbmt-" + Integer(rand()*999999999).to_s
    b1 = submit_tag(value, options.reverse_merge(:onclick => "$(this).hide(); $('#{id}').show();") )
    b2 = submit_tag("     ", :id => id, :disabled => true, :class=> "disabled-input", :style=> "display: none;" )

    return b1 + b2
  end

  def item_list_header(title, company, show_company_name = false)

    if !company.az_tariff.show_logo_and_site
      return ''
    end

    image = image_tag(company.logo.url(:main), :alt => "#{company.name}")
    
    if company.logo_file_name == nil && permitted_to?(:manage_company, company)
      image = link_to(image, edit_az_company_path(company), :title => 'Щелкните, чтобы загрузить логотип')
    end
    company_name = ""
    if show_company_name
      company_name = " (#{company.name})"
    end
    return "<table><tr><td style='width: 120px'>#{image}</td><td><h1>#{title}#{company_name}</h1></td></tr></table>"
    
  end


  def company_site_and_logo_for_visitor(company, show_logo, show_site)
    if company.az_tariff.show_logo_and_site != true
      return ''
    end
    image = ""
    if show_logo
      image = image_tag(company.logo.url(:main), :alt => "#{company.name}")
    end

    site = ""
    if show_site
      site = link_to(h(company.site), company.site, :title => company.name)
    end
    return "<table><tr><td class='visitor-logo'>#{image}</td><td class='visitor-company'><h2>#{company.name}</h2></td><td class='visitor-site'>#{site}</td> </tr></table><hr/>"

  end

  def dialog_title(title, title_class=nil, title_id=nil)
    return "<h3>#{title}</h3>"
  end

  def page_dialog_title(title, page, title_class=nil, title_id=nil)
    return dialog_title("#{title} (#{page.name})", title_class, title_id)
  end

  def project_access_icon(project)
    if project.public_access 
      return image_tag('unlock.png', :title => 'Публичный доступ к проекту') 
    end
    return image_tag('lock.png', :title => 'Приватный проект')
  end

end

def is_node_collapsed(path)
  if session[:collapsed] == nil
    return false
  else
    if session[:collapsed][path] == nil || session[:collapsed][path] == false
      return false
    end
  end
  return true
end