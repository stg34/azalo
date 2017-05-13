require 'rubygems'
require 'fileutils'

class AzDesignsController < ApplicationController

  #filter_access_to :new, :create
  #filter_access_to :all, :attribute_check => true
  filter_access_to :all

  layout 'main'

  Design_dir = "/dezzign"

  # GET /az_designs
  # GET /az_designs.xml
  def index
    @designs = AzDesign.paginate(:all, :conditions => {:copy_of => nil}, :order => 'created_at desc', :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      #format.xml { render :xml => @az_designs }
    end
  end

  # GET /az_designs/1
  # GET /az_designs/1.xml
#  def show
#    @az_design = AzDesign.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml { render :xml => @az_design }
#    end
#  end

  # GET /az_designs/new
  # GET /az_designs/new.xml
#  def new
#    @az_design = AzDesign.new
#    @az_design.design_rnd = Integer(rand()*100000000)
#    perpare_images(@az_design)
#    #@az_design.az_page_id = params[:az_page_id]
#
#    respond_to do |format|
#      format.html { render :partial => 'new_edit'}
#      #format.xml  { render :xml => @az_design }
#    end
#  end

  # GET /az_designs/1/edit
#  def edit
#    @az_design = AzDesign.find(params[:id])
#  end

  # POST /az_designs
  # POST /az_designs.xml
  def create
    @az_design = AzDesign.new(params[:az_design])
    page = AzPage.find(params[:az_design][:id])
    @az_design.az_page = page
    @az_design.owner_id = page.owner_id
    image = AzImage.find_by_az_design_id(-Integer(params[:az_design][:design_rnd]))
    source = AzDesignSource.find_by_az_design_id(-Integer(params[:az_design][:design_rnd]))

    tmp_dir = Dir.tmpdir()

    tmp_file_dir = tmp_dir + Design_dir + "/-" + (params[:az_design][:design_rnd])

    begin
      tmp_list = Dir.entries(tmp_file_dir)
      tmp_list.each do |tmp_file_name|
        if !(tmp_file_name == "." || tmp_file_name == "..")
          File.open(tmp_file_dir + "/" + tmp_file_name) { |f| @az_design.design_source = f }
          File.delete(tmp_file_dir + "/" + tmp_file_name)
          break
        end
      end
    rescue => err
      puts "=================================================================================="
      puts err
      puts @az_design.inspect
      puts "=================================================================================="
    end

    dez_ret = @az_design.save

    img_ret = true
    src_ret = true
    if image != nil && dez_ret
      image.az_design_id = @az_design.id
      image.owner_id = @az_design.owner_id
      img_ret = image.save
    end

    if source != nil && dez_ret
      source.az_design_id = @az_design.id
      source.owner_id = @az_design.owner_id
      src_ret = source.save
    end

    respond_to do |format|
      if dez_ret && img_ret && src_ret
        format.html { render :text => "Ok" }
        #format.html { render :text => 'Успешно. Подожите...<script type="text/javascript">reload_page();</script>' }
        #format.xml  { render :xml => @az_design, :status => :created, :location => @az_design }
      else
        format.html { render :partial => '/az_pages/tooltips/add_update_design_dialog', 
            :locals=> {:design => @az_design,
                       :image => image,
                       :source => source,
                       :design_action => :new},
            :status => 406}
        #format.xml  { render :xml => @az_design.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_designs/1
  # PUT /az_designs/1.xml
  def update
    @az_design = AzDesign.find(params[:id])

    design_rnd = Integer(params[:az_design][:design_rnd])
    puts "---------------------------------------------------------------------"
    puts design_rnd
    image = AzImage.find_by_az_design_id(-design_rnd)
    if image != nil
      image.az_design_id = @az_design.id
      image.owner_id = @az_design.owner_id
      img_ret = image.save
    else
      img_ret = true
    end

    source = AzDesignSource.find_by_az_design_id(-design_rnd)
    if source != nil
      if @az_design.az_design_source == nil
        @az_design.az_design_source = source
        source.owner_id = @az_design.owner_id
        src_ret = @az_design.save
      else
        old_src = AzDesignSource.find(@az_design.az_design_source.id)
        @az_design.az_design_source = source
        @az_design.az_design_source.owner_id = @az_design.owner_id
        @az_design.az_design_source.save
        @az_design.save
        old_src.destroy
        src_ret = true
      end
    else
      src_ret = true
    end

#    if @az_design.design_tmp_source != nil
#      @az_design.design_source = @az_design.design_tmp_source
#      @az_design.design_tmp_source = nil
#    end

    #puts image

    respond_to do |format|
      if @az_design.update_attributes(params[:az_design]) && img_ret && src_ret #TODO update_attributes заменить на рукопашное заполнение параметров
        format.html { render :text => "Ok" }
        format.xml  { head :ok }
      else
        #format.html { render :action => "edit" }
        format.html { render :partial => '/az_pages/tooltips/add_update_design_dialog', 
            :locals=> {
                :design => @az_design,
                :image => image,
                :source => source,
                :design_action => :update},
            :status => 406}
        #format.xml  { render :xml => @az_design.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_designs/1
  # DELETE /az_designs/1.xml
#  def destroy
#    @az_design = AzDesign.find(params[:id])
#    @az_design.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(az_designs_url) }
#      format.xml  { head :ok }
#    end
#  end

  def update_design
    design = AzDesign.find(params[:id])
    #perpare_images(design)

    design.design_rnd = Integer(rand()*100000000)

    puts design.inspect

    respond_to do |format|
      format.html {render(:partial => '/az_pages/tooltips/add_update_design_dialog_container', 
                          :locals => {:design => design, :image => nil, :source => nil, :first_design => nil, :design_action => :update })}
      format.xml  { head :ok }
    end
  end

  def new_design

    page = AzPage.find(params[:id])
    first_design = (page.az_designs.size == 0)

    design = AzDesign.new
    design.az_page = page
    design.owner = page.owner
    design.design_rnd = Integer(rand()*100000000)
    perpare_images(design)

    if first_design
      design.description = 'Основной дизайн'
    end

    puts design.inspect

    respond_to do |format|
      format.html {render(:partial => '/az_pages/tooltips/add_update_design_dialog_container', 
                          :locals => {:design => design, :image => nil, :source => nil, :first_design => first_design, :design_action => :new })}
      format.xml  { head :ok }
    end
  end


  def add_source
    id = Integer(params[:id])

    puts "---------------------------------------------------------------------"
    puts params[:design_rnd]
    puts id
    puts "---------------------------------------------------------------------"

    design_alredy_exists = id > 0

    file_name = File.basename(params[:qqfile]).gsub(/[^\w\.\-]/, '_')
    tmp_dir = Dir.tmpdir()

    # < 0 в том случае, если загружается файл к дизайну, который еще не создан.

    tmp_file_dir = tmp_dir + Design_dir + "/" + params[:design_rnd]
    tmp_file_name = tmp_file_dir + "/" + file_name
    FileUtils.makedirs(tmp_file_dir)

    f = File.new(tmp_file_name, 'wb')
    f.syswrite(request.raw_post)
    f.close

    ret = true
    error_msg = ''

    if design_alredy_exists
      @design = AzDesign.find(id)
      @design.design_tmp_source_magic = Integer(params[:design_rnd])
      File.open(tmp_file_name) { |ff| @design.design_tmp_source = ff
        puts "***"
        puts ff.size
        puts "***"
      }
      File.delete(tmp_file_name)
      begin
      @design.save!
      rescue Exception => e
        ret = false
        puts e.message
        error_msg = e.message
      end
      puts ret
      puts "---------------------------------------------------------------------"
    end
    
    respond_to do |format|
      if ret
        format.html { render :text => "{success:true}" }
      else
        format.html { render :text => "{error:'#{e.message}'}" }
        #format.xml  { render :xml => @az_design.errors, :status => :unprocessable_entity }
      end
    end

  end

  def destroy
    design = AzDesign.find(params[:id])

    prj = design.az_page.get_project_over_block

    design.destroy

    respond_to do |format|
      #puts "redirection to project"
      format.html { redirect_to(prj) }
      #format.xml  { head :ok }
    end
  end

  def destroy2
    design = AzDesign.find(params[:id])

    design.destroy

    respond_to do |format|
      #puts "redirection to project"
      format.html { render(:text => 'Ok') }
      #format.xml  { head :ok }
    end
  end

#  def new_source
#    puts '====================================================================='
#    design_id = Integer(params[:id])
#    if design_id > 0
#      @design = AzDesign.find(design_id)
#    else
#      @design = AzDesign.new
#      @design.design_rnd = -design_id
#      puts @design.design_rnd
#    end
#
#    respond_to do |format|
#      format.html { render :template => '/az_designs/new_source', :layout => "popup_iframe"}
#      #format.xml  { head :ok }
#    end
#  end

#  def create_source
#    #puts '====================================================================='
#    #puts params.inspect
#    #puts params[:az_design][:design_tmp_source]
#
#    ret = true
#    original_path = nil
#
#    id = Integer(params[:id])
#    design_rnd = id
#    if params[:az_design] && params[:az_design][:design_tmp_source]
#      original_path = params[:az_design][:design_tmp_source].original_path
#    end
#
#    design_alredy_exists = id > 0
#
#    if !design_alredy_exists && original_path != nil
#      @design = AzDesign.new
#      file_name = File.basename(original_path).gsub(/[^\w\.\-]/, '_')
#
#      tmp_dir = Dir.tmpdir()
#      tmp_file_dir = tmp_dir + Design_dir + "/" + design_rnd.to_s
#      tmp_file_name = tmp_file_dir + "/" + file_name
#      FileUtils.makedirs(tmp_file_dir)
#
#      f = File.new(tmp_file_name, 'wb')
#      f.syswrite(params[:az_design][:design_tmp_source].read)
#
#      @design.design_tmp_source_file_name = file_name
#      @design.design_tmp_source_file_size = f.size
#
#      f.close
#
#    end
#
#    if design_alredy_exists
#      @design = AzDesign.find(id)
#      @design.design_tmp_source = params[:az_design][:design_tmp_source]
#      ret = @design.save
#    else
#
#    end
#    #@design.az_design_id = -Integer(params[:az_image][:az_design_id])
#    #@design.owner_id = -Integer(params[:az_image][:az_design_id])
#
#    respond_to do |format|
#      if ret
#        #puts "ok"
#        format.html { render :template => "/az_designs/show_source", :layout => "popup_iframe"}
#        #format.xml  { render :xml => @design, :status => :created, :location => @design }
#      else
#        #puts "error"
#        #puts "============================"
#        #@design.az_design_id = -@design.az_design_id
#        format.html { render :template => "/az_images/new_source", :layout => "popup_iframe"}
#      end
#    end
#  end

  private
  def perpare_images(design)
    design.az_images.build
  end

end
