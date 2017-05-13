class AzPagesController < ApplicationController

  layout "main"

#  filter_access_to :designs_tooltip, :attribute_check => true
#  filter_access_to :description_tooltip, :attribute_check => true
#  filter_access_to :collapse_node, :attribute_check => true
#  filter_access_to :expand_node, :attribute_check => true
#  filter_access_to :all
  filter_access_to :new, :create, :new_sub_page, :expand_node, :collapse_node, :index
  filter_access_to :all, :attribute_check => true

  def index
    @pages = AzPage.paginate(:all, :conditions => {:copy_of => nil, :root => nil}, :order => 'id desc', :page => params[:page])
    
    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @az_page }
      #format.xml  { render :xml => @az_page.deep_xml() }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @az_page = AzPage.find(params[:id])
    @title = 'Страница "' + @az_page.name + '" cайта "' + @az_page.get_project_over_block.name + '"'

    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @az_page }
      format.xml  { render :xml => @az_page.deep_xml() }
    end
  end

  # GET /pages/new
  def new
    #puts params.inspect
    @az_page = AzPage.new

    if params[:project_id]
      az_project = AzBaseProject.find(params[:project_id])
      @az_page.az_base_project = az_project
    else
      # TODO wtf?
    end

    respond_to do |format|
      format.html { render :partial => '/az_pages/tooltips/new_edit_dialog', :locals=> {:page => @az_page, :show_page_type => true}}
    end
  end

  def new_sub_page
    @az_page = AzPage.new
    parent = AzPage.find(params[:az_page_id])
    @az_page.az_base_project = parent.get_project
    @az_page.parents << parent
    respond_to do |format|
      format.html { render :partial => '/az_pages/tooltips/new_edit_dialog',
              :locals=> {:page => @az_page,
                         :parent_page_id => params[:az_page_id]}}
    end
  end

  def edit_page
    #puts "---------------- edit_page ---------------------"
    #puts params.inspect
    @az_page = AzPage.find(params[:id])

    #show_page_type = (@az_page.parent == nil)
    show_page_type = true


    respond_to do |format|
      format.html { render :partial => '/az_pages/tooltips/new_edit_dialog', 
        :locals=> {:page => @az_page,
                   :parent_page_id => nil}}
    end
  end
  
  # POST /pages
  # POST /pages.xml
  def create
    @az_page = AzPage.new(params[:az_page])
    parent_page = AzPage.find_by_id(params[:az_page][:parent_id])
    @az_page.owner_id = parent_page.owner_id
    @az_page.parents << parent_page
    @az_page.position = 0

    if @az_page.title == nil || @az_page.title == ''
      @az_page.title = @az_page.name
    end

    save_result = @az_page.save

    respond_to do |format|
      if save_result
        format.html { render :text => "Успешно. Подождите...<script type='text/javascript'>add_sub_tree(#{@az_page.id}, #{parent_page.id});</script>" }
      else
        format.html { render :partial => '/az_pages/tooltips/new_edit_dialog',
                :locals=> {:page => @az_page, :parent_page_id => params[:az_page][:parent_id]}}
        
      end
    end
  end

  def update
    @az_page = AzPage.find(params[:id])

#    if !params[:az_page][:parent_id].blank?
#      parent_page = AzPage.find(params[:az_page][:parent_id])
#      if @az_page.is_my_child(parent_page)
#        params[:az_page][:parent_id] = @az_page.parent_id
#      end
#    end

    if params[:az_page][:page_type] == nil
      params[:az_page][:page_type] = false
    end

    #params[:az_page][:az_base_project_id] = @az_page.get_project.id

    name_changed = (@az_page.name != params[:az_page][:name])
    # TODO с этими сравнениями надо что-то сделать...
    page_type_changed = false
    embedded_changed = false
    if params[:az_page][:page_type]
      page_type_changed = ((@az_page.page_type == 1) != (params[:az_page][:page_type] == '1'))
    end
    if params[:az_page][:embedded]
      embedded_changed = (@az_page.embedded != (params[:az_page][:embedded] == '1'))
    end

    puts name_changed
    puts page_type_changed
    puts embedded_changed

    @az_page.name = params[:az_page][:name]
    @az_page.embedded = params[:az_page][:embedded]
    @az_page.page_type = params[:az_page][:page_type]
    new_page_type = @az_page.page_type == AzPage::Page_admin ? 'admin' : 'user';
    new_embedded_type = @az_page.embedded ? 'embedded' : '';
    res = @az_page.save
    respond_to do |format|
      if res
        if page_type_changed || embedded_changed || name_changed
          format.html { render :text => "Успешно. Подождите...<script type='text/javascript'>update_page_name_and_type(#{@az_page.id}, '#{@az_page.name}', '#{new_page_type}', '#{new_embedded_type}');</script>" }
        else
          format.html { render :text => "Успешно. <script type='text/javascript'>Windows.closeAll();</script>" }
        end
      else
        format.html { render :partial => '/az_pages/tooltips/new_edit_dialog',
                :locals=> {:page => @az_page, :parent_page_id => params[:az_page][:parent_id]}}
      end
    end
  end

  def add_data_type
    page = AzPage.find(params[:id])
    data_type = AzBaseDataType.find(params[:data_type_id])
    types = page.types.select{|dt| dt.id == data_type.id}
    res = true
    if types.size == 0
      tp = AzTypedPage.new(:az_page_id => page.id, :az_base_data_type_id => data_type.id)
      tp.owner_id = page.owner_id
      res = tp.save
      #page.types << data_type
    end

    respond_to do |format|
      if res
        format.html { render(:text => 'Ok')}
      else
        format.html { render :text => "error" }
      end
    end
  end

  def remove_data_type
    page = AzPage.find(params[:id])
    data_type_id = params[:data_type_id]
    data_type = AzTypedPage.find(:first, :conditions => {:az_page_id => page.id, :az_base_data_type_id => data_type_id} )
    res = false
    if data_type != nil
      res = true
      data_type.destroy
    end

    respond_to do |format|
      if res
        format.html { render(:text => 'Ok')}
      else
        format.html { render :text => "error" }
      end
    end
  end


#  def remove_type
#    @az_page = AzPage.find(params[:id])
#    @project = AzBaseProject.find(params[:project_id])
#
#    # TODO move to model
#    type_id = Integer(params[:az_page][:type_ids])
#    tp = AzTypedPage.find(:first, :conditions => {:az_page_id => @az_page.id, :az_base_data_type_id => type_id} )
#    if tp != nil
#      if (tp.az_page.id == @az_page.id)
#        tp.destroy
#      end
#    end
#    # TODO end
#
#    res = true
#
#    respond_to do |format|
#      if res
#        format.html { render(:partial => 'show_page_box_content', :locals => {:page => @az_page, :project => @project})}
#      else
#        # TODO tv_snow wouldn't removed
#        format.html { render :text => "error" }
#      end
#    end
#  end

  # DELETE /pages/1
  # DELETE /pages/1.xml

#  def destroy_common
#    # TODO ниже еще одна функция destroy_common
#    @az_page = AzPage.find(params[:id])
#    project = @az_page.get_project
#
#    if !@az_page.page_in_assigned_block?
#      @az_page.destroy
#    end
#
#    respond_to do |format|
#      format.html { redirect_to(project) }
#      format.xml  { head :ok }
#    end
#  end

  def destroy
    page = AzPage.find(params[:id])
    destroy_common(page, page.az_base_project)
  end

  def destroy_bp
    page = AzPage.find(params[:id])
    destroy_common(page, page.get_project_over_block)
  end

  def destroy_lnk
    #project = AzBaseProject.find(params[:project_id])
    parent_page_id = params[:parent_page_id]
    page_id = params[:id]
    #page_link = AzPageAzPage.find(params[:link_id])
    page_link = AzPageAzPage.find(:first, :conditions => {:parent_page_id => parent_page_id, :page_id => page_id})
    ret = true
    if page_link
      if page_link.az_page.embedded && page_link.az_parent_page.root
        # Если удаляется страница, которая является внедряемой и удаляется от корня компонента, то удаляем её сразу
        page_link.az_page.destroy
      else
        page_link.destroy
      end
    else
      ret = false
    end
    respond_to do |format|
      #format.html { redirect_to(project) }
      if ret
        format.html { render :text => 'OK' }
      else
        format.html { render :text => 'Error. Link not found.', :status => :not_acceptable }
      end
    end
  end

  # MOVE_UP /pages/move_up/1
  def move_up
    page_id = Integer(params[:id])
    parent_page_id = Integer(params[:parent_page_id])

    link = AzPageAzPage.find(:first, :conditions => {:page_id => page_id, :parent_page_id => parent_page_id})


    parent_page = AzPage.find(parent_page_id)
    project = parent_page.az_base_project
    parent_link = nil
    if parent_page.parent_links.size > 0
      parent_link = parent_page.parent_links[0]
    end
    tree = PrTree.build_sub_tree(project, parent_link, 2)
#    tree.walk do |node|
#      puts node.main_page.name
#    end

    move_link_id = -1
    tree.root.get_children.each do |node|
      #puts "#{node.main_page.name} --- #{node.get_link.position} --- #{node.main_page.id}"
      #puts "#{node.main_page.id} == #{page_id}"
      if node.main_page.id == page_id
        move_link_id = node.get_link.id
      end
    end

    #puts page_id
    #puts move_link_id
    res = true
    
    if move_link_id != -1
      links = tree.root.get_children.collect{|node| node.get_link}
      move_link_id_pos = links.index{|l| l.id == move_link_id}
      #puts move_link_id_pos

      if move_link_id_pos != nil && move_link_id_pos != 0
        links.each_with_index do |link, i|
          if i == move_link_id_pos - 1
            link.position = i + 1
            #puts link.position
            link.save!
          elsif i == move_link_id_pos
            link.position = i - 1
            #puts link.position
            link.save!
          else
            link.position = i
            #puts link.position
            link.save!
          end
        end
      end
    else
      res = false
    end
    ############################################
    respond_to do |format|
      if res
        format.html { render :text => "ok" }
      else
        format.html { render :text => "Link not found", :status => 	:not_acceptable }
      end
    end
  end

  # MOVE_UP /pages/move_down/1
  def move_down
    page_id = params[:id]
    parent_page_id = params[:parent_page_id]

    link = AzPageAzPage.find(:first, :conditions => {:page_id => page_id, :parent_page_id => parent_page_id})
    res = true
    if link
      move_link_id = link.id
      parent_page = link.az_parent_page

      if parent_page.parents.size == 0
        link_with_parent_page = nil
      else
        link_with_parent_page = parent_page.parent_links[0]
      end

      tree = PrTree.build_sub_tree(parent_page.az_base_project, link_with_parent_page, 2)
      link_ids = tree.root.get_children.collect{|node| node.get_link.id}

      move_link_id_idx = link_ids.index(move_link_id)
      if move_link_id_idx && move_link_id_idx < link_ids.size - 1
        link_ids.delete_at(move_link_id_idx)
        link_ids.insert(move_link_id_idx + 1, move_link_id)
      end

      link_ids.each_with_index do |link_id, i|
        link = AzPageAzPage.find(link_id)
        if link
          link.position = i
          link.save!
        end
      end
    else
      res = false
    end

    respond_to do |format|
      if res
        format.html { render :text => "ok" }
      else
        format.html { render :text => "Link not found", :status => 	:not_acceptable }
      end
    end
  end

  # MOVE_UP /pages/move_up/1/positions
#  def move_up1
#    page = AzPage.find(params[:id])
#    positions = params[:positions]
#    page_and_position = parse_positions(positions)
#
#    move_up_down(page, page_and_position, -1, 'position')
#
#    #page.move_up
#    respond_to do |format|
#      format.html { redirect_to :back } # TODO check if referer present!
#      format.xml  { render :xml => @az_page }
#    end
#  end

  # MOVE_UP /pages/move_down/1/positions
#  def move_down1
#    page = AzPage.find(params[:id])
#    positions = params[:positions]
#    page_and_position = parse_positions(positions)
#
#    move_up_down(page, page_and_position, 1, 'position')
#
#    #page.move_down
#    respond_to do |format|
#      format.html { redirect_to :back } # TODO check if referer present!
#      format.xml  { render :xml => @az_page }
#    end
#  end

  def move_tr_up
    page = AzPage.find(params[:id])
    positions = params[:positions]
    page_and_position = parse_positions(positions)

    begin
      delta = -Integer(params[:delta])
    rescue
      delta = -1
    end

    move_up_down(page, page_and_position, delta, "tr_position")

    #page.move_up
    respond_to do |format|
      format.html { render :text => "ok" }
      format.xml  { render :xml => @az_page }
    end
  end

  # MOVE_UP /pages/move_down/1/positions
  def move_tr_down
    page = AzPage.find(params[:id])
    positions = params[:positions]

    begin
      delta = Integer(params[:delta])
    rescue
      delta = 1
    end

    page_and_position = parse_positions(positions)
    move_up_down(page, page_and_position, delta, "tr_position")

    #page.move_down
    respond_to do |format|
      format.html { render :text => "ok" }
      format.xml  { render :xml => @az_page }
    end
  end

  def attach_component_page
    az_page = AzPage.find(params[:id])
    component_page = AzPage.find(params[:component_page_id])

    if az_page.root && component_page.embedded # TODO вынести в валидатор
      res = false
    else
      res = az_page.children << component_page
    end
    
    respond_to do |format|
      if res
        format.html { render :text => "Ok" }
      else
        format.html { render :text => "Ok", :status => 	:not_acceptable }
      end
    end
  end

  def remove_component_page
    az_page = AzPage.find(params[:id])
    component_page = AzPage.find(params[:component_page_id])

    res = az_page.children.delete(component_page)

    respond_to do |format|
      if res
        format.html { render :text => "Ok" }
      else
        format.html { redirect_to(@az_page.get_project) }
      end
    end
  end

  def page_box_content
    page = AzPage.find(params[:id])
    respond_to do |format|
      format.html { render(:partial => 'show_page_box_content', :locals => {:page => page})}
    end
  end

  def designs_tooltip
    @az_page = AzPage.find(params[:id])
    respond_to do |format|
      format.html { render(:partial => '/az_pages/tooltips/designs_tooltip', :locals => {:page => @az_page})}
      #format.xml  { render :xml => @az_pages }
    end
  end

  def description_dialog

    page = AzPage.find(params[:id])
    texts = page.get_tr_texts
    respond_to do |format|
      format.html { render(:partial => '/az_pages/tooltips/description_page_dialog_container', 
                      :locals => {:page => page,
                                  :page_to_update => page,
                                  :embedded_page => false,
                                  :update_tr => false,
                                  :texts => texts} )}
    end
  end

  def tr_description_tooltip
    page = AzPage.find(params[:id])
    return tr_description_tooltip_common(page, page)
  end

  def tr_description_wo_title_tooltip
    page = AzPage.find(params[:id])
    page_to_update = AzPage.find(params[:update_page_id])
    return tr_description_tooltip_common(page, page_to_update)
  end

  def tr_description_tooltip_common(page, page_to_update)
    embedded_page = (page_to_update.id != page.id)
    texts = page.get_tr_texts
    respond_to do |format|
      format.html { render(:partial => '/az_pages/tooltips/description_page_dialog_container', 
              :locals => {:page => page,
                          :page_to_update => page_to_update,
                          :embedded_page => embedded_page,
                          :update_tr => true,
                          :texts => texts})}
    end
  end

  def description_wo_title_dialog
    page = AzPage.find(params[:id])
    page_to_update = AzPage.find(params[:update_page_id])
    texts = page.get_tr_texts
    respond_to do |format|
      format.html { render(:partial => '/az_pages/tooltips/description_page_dialog_container', 
                      :locals => {:page => page,
                                  :page_to_update => page_to_update,
                                  :embedded_page => true,
                                  :update_tr => false,
                                  :texts => texts})}
    end
  end

  # TODO устаревшая функция
  def tr_page_position_dialog
    page = AzPage.find(params[:id])
    respond_to do |format|
      format.html { render(:partial => '/az_pages/tooltips/tr_position_edit_dialog', :locals => {:page => page})}
    end
  end

  def tr_page_status_dialog
    page = AzPage.find(params[:id])
    statuses = @az_page.statuses_for_select
    respond_to do |format|
      format.html { render(:partial => '/az_pages/tooltips/tr_status_edit_dialog', :locals => {:page => page, :statuses => statuses})}
    end
  end

  def new_design
    page = AzPage.find(params[:id])
    perpare_design(page)

    respond_to do |format|
      format.html {render(:partial => '/az_pages/tooltips/add_design_dialog', :locals => {:page => page})}
      format.xml  { head :ok }
    end
  end

  def download_designs_dialog
    #puts params.inspect
    page = AzPage.find(params[:id])

    respond_to do |format|
      format.html { render :partial => '/az_pages/tooltips/download_designs_dialog', :locals=> {:page => page, :designs => page.get_designs}}
    end
  end


  def add_page_parent
    page = AzPage.find(params[:id])
    ret = true
    error_message = 'Error'
    if params[:parent_id] != nil
      parent_page = AzPage.find(params[:parent_id])

      page.position = parent_page.get_max_children_position + 1

      children = page.get_descendants
      child = children.select { |p| p.id == parent_page.id }
      children.each do |p|
        puts p.inspect
      end
      if child.size != 0 || page.id == parent_page.id
        flash[:notice] = 'Отклонено. Зацикливание!'
        error_message = 'Error. Отклонено. Зацикливание!'
        ret = false
      else
        page.parents << parent_page
      end
    else
      page.parent = nil
    end

    respond_to do |format|
      if page.save && ret
        format.html { render :text => 'OK' }
      else
        format.html { render :text => error_message, :status => 	:not_acceptable }
      end

    end
  end

  def change_page_parent
    page = AzPage.find(params[:id])

    #old_parent_id = params[:old_parent_id]
    new_parent_id = params[:new_parent_id]
    page_link = AzPageAzPage.find(params[:link_id])
    #page_link = AzPageAzPage.find(:first, :conditions => {:page_id => page.id, :parent_page_id => old_parent_id})

    old_parent = page_link.az_parent_page
    new_parent = AzPage.find(new_parent_id)

    parent_change_ret = false
    if page_link && !page.embedded && old_parent && new_parent
      old_parent_page = page_link.az_parent_page
      parent_page = AzPage.find(new_parent_id)

      page.position = parent_page.get_max_children_position + 1
      #page.page_type = parent_page.get_page_type

      children = page.get_descendants
      child = children.select { |p| p.id == parent_page.id }
      #children.each do |p|
      #  puts p.inspect
      #end
      parent_change_ret = true
      if child.size != 0 || page.id == parent_page.id
        #flash[:notice] = 'Отклонено. Зацикливание!'
        parent_change_ret = false
      else
        begin
          page_link.az_parent_page = parent_page
          page_link.save
        rescue
          parent_change_ret = false
        end
      end
      
    end

    respond_to do |format|
      if page.save && parent_change_ret
        format.html { render :text => 'OK' }
      else
        format.html { render :text => 'Error.', :status => 	:not_acceptable }
        #format.html { render :text => 'Успешно. Подождите...<script type="text/javascript">reload_page();</script>' }
      end

    end
  end

  def update_description_and_title
    update_description_and_title_common(:project)
  end

  def tr_public_update_description_and_title
    update_description_and_title_common(:tr_public)
  end

  def tr_admin_update_description_and_title
    update_description_and_title_common(:tr_admin)
  end

  def update_description_and_title_common(tr)
    page = AzPage.find(params[:id])
    page.description = params[:az_page][:description]
    page.title = params[:az_page][:title]
    res = page.save

    respond_to do |format|
      if res
        if tr == :project
          page_to_update_id = Integer(params[:page_to_update])
          #format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_page_box2(#{page_to_update_id}, 'description');</script>" }
          #format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); alert('description');</script>" }
          format.html { render :text => "Ok" }
        elsif tr == :tr_public
          format.html { render :text => "Ok" }
          #format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_page_box(1);</script>" }
        else
          format.html { render :text => "Ok" }
          #format.html { render :text => "<script type='text/javascript'>Windows.closeAll(); update_page_box(2);</script>" }
        end
      else
        flash[:notice] = 'Ошибка'
        format.html { render :text => 'Успешно. Подождите...<script type="text/javascript">reload_page();</script>' }
      end
    end
  end

  def set_design_source
    src_id = params[:source_id]
    dst_id = params[:id]

    page = AzPage.find(dst_id)

    ret = true

    if src_id != nil
      source_page = AzPage.find(src_id)
      if !source_page.is_page_in_design_sources(page)
        page.design_source = source_page
      else
        #flash[:notice] = 'Отклонено'
        ret = false
      end
    else
      page.design_source = nil
    end

    page.save

    respond_to do |format|
      if ret
        format.html { render :text => 'Ok' }
      else
        format.html { render :text => 'Error. Зацикливание', :status => :not_acceptable }
      end
    end
  end

  def update_tr_page_position
    page = AzPage.find(params[:id])
    if page
      page.tr_position = params[:az_page][:tr_position]
    end

    page.save

    respond_to do |format|
      format.html { render :text => 'Успешно. Подождите...<script type="text/javascript">reload_page("' + page.id.to_s + '");</script>' }
    end
  end

  def update_tr_page_status
    page = AzPage.find(params[:id])
    if page
      page.status = params[:az_page][:status]
    end

    page.save

    respond_to do |format|
      format.html { render :text => 'ok' }
    end
  end


#  def set_functionality_source
#
#    page = AzPage.find(params[:id])
#    if params[:source_id] != nil
#      source_page = AzPage.find(params[:source_id])
#      if !source_page.is_page_in_functionality_sources(page)
#        page.functionality_source = source_page
#      else
#        flash[:notice] = 'Отклонено'
#      end
#    else
#      page.functionality_source = nil
#    end
#
#    page.save
#
#    respond_to do |format|
#      format.html { render :text => 'Ok' }
#    end
#  end

  def collapse_node
    puts "collapse_node 1 -----------------------------------------------------------------"
    if session[:collapsed] == nil
      session[:collapsed] = {}
    end

    puts "collapse_node 2 -----------------------------------------------------------------"
    session[:collapsed][params[:id]] = true
    puts session[:collapsed].inspect

    respond_to do |format|
      format.html { render :text => 'Ok' }
    end
    
  end

  def expand_node
    puts "expand_node 1 -----------------------------------------------------------------"
    if session[:collapsed] == nil
      session[:collapsed] = {}
    end
    
    puts "expand_node 2 -----------------------------------------------------------------"
    session[:collapsed][params[:id]] = false
    puts session[:collapsed].inspect

    respond_to do |format|
      format.html { render :text => 'Ok' }
    end
  end

  def get_page_description
    page = AzPage.find(params[:id])
    respond_to do |format|
      format.html { render :partial => '/az_pages/generated_description', :locals=> {:page => page}}
    end
  end

  def get_page_description1
    tr_text = AzTrText.find(params[:tr_text_id]);
    page = AzPage.find(params[:id])
    data_type_id = Integer(params[:data_type_id])
    if data_type_id > 0
      data_type = AzBaseDataType.find(params[:data_type_id])
    else
      data_type = nil
    end

    link = page.parent_links[0]
    tree = PrTree.build_sub_tree(nil, link, 2)
    
    text = tr_text.get_description(tree.root, data_type)
    respond_to do |format|
      format.html { render :text => text}
    end
  end

  def page_box
    page = AzPage.find(params[:id])

    @show_type = show_type_str_to_sym(params[:show_mode])
    
    respond_to do |format|
      format.html { render :partial => '/az_pages/page_box_content', :locals=> {:page => page, :project => page.get_project_over_block, :update_dependent => true, :show_mode => @show_type}}
    end
  end

  def page_tr
    page = AzPage.find(params[:id])
    project = page.get_project_over_block
    permitted_to_edit = permitted_to?(:edit, project)
    permitted_to_show = permitted_to?(:show, project)
    respond_to do |format|
      format.html { render :partial => '/az_base_projects/tr_edit/page', :locals => {:page => page, :permitted_to_edit => permitted_to_edit, :permitted_to_show => permitted_to_show}}
    end
  end

  def tr_page_status_color
    page = AzPage.find(params[:id])
    respond_to do |format|
      format.html { render :text => status_color = Statuses::Statuses[page.status][:color]}
    end
  end



  private

  def perpare_design(page)
    page.az_designs.build
    page.az_designs.each do |d|
      d.az_images.build
    end
  end

  def destroy_common(page, redirect)
    # TODO выше еще одна функция destroy_common
    @az_page = page
    #project = @az_page.get_project

    #if !@az_page.page_in_assigned_block?
    #  @az_page.destroy
    #end

    if !@az_page.root
      # Root page can be deleted only with project
      @az_page.destroy
    end

    respond_to do |format|
      format.html { redirect_to(redirect) }
      format.xml  { head :ok }
    end
  end

  def parse_positions(positions)
    page_position = positions.split(';')
    page_and_position = []
    page_position.each do |pp|
      page_id, position= pp.split(',')
      page_and_position << [Integer(position), Integer(page_id)]
    end
    page_and_position.sort{|a, b| a[0] <=> b[0]}
    return page_and_position
  end

  def move_up_down(page, page_and_position, delta, position_field_name)
    #move_next_page = false

    page_ids = page_and_position.collect{|pnp| pnp[1]}

    reverse = false
    if delta < 0
      reverse = true
      page_ids.reverse!
    end

    delta = delta.abs

    if page.id == page_ids[page_ids.size - 1]
      # Если сдвиг вниз и сдвигаемея страница последняя - ничего не делаем
      # Если сдвиг вверх и сдвигаемая страница первая - ничего не делаем
      #puts "RETURN ==========================================================================="
      return
    end

    page_idx = page_ids.index(page.id)

    #puts "1 ------------------------------------------------------------------------"
    #puts delta
    #puts page.id
    #puts page_ids.inspect

    if page_idx == nil
      # Never should be here
      return
    end

    new_idx = page_idx + delta

    if new_idx >= page_ids.size
      new_idx = page_ids.size - 1
    end

    page_ids.delete_at(page_idx)

    #puts "2 ------------------------------------------------------------------------"
    #puts page_ids.inspect

    page_ids.insert(new_idx, page.id)

    #puts "3 ------------------------------------------------------------------------"
    #puts page_ids.inspect

    n = 0
    if reverse
      page_ids.reverse!
    end
    page_ids.each do |pid|
      pg = AzPage.find(pid)
      pg[position_field_name] = n
      pg.save
      n += 1
    end
  end

end

