class AzImagesController < ApplicationController

  filter_access_to :all

  layout 'main'

  # GET /az_images
  # GET /az_images.xml
  def index
    #@images = AzImage.find(:all)
    @images = AzImage.paginate(:all, :conditions => {:copy_of => nil}, :order => 'created_at desc', :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /az_images/1
  # GET /az_images/1.xml
  def show
    @image = AzImage.find(params[:id])

    respond_to do |format|
      #format.html # show.html.erb
      format.html { render :template => "/az_images/show", :layout => "popup_iframe"}
    end
  end


#  def tr_doc_show
#    @image = AzImage.find(params[:id])
#    send_file @image.image.path(:big)
#  end

  # GET /az_images/new
  # GET /az_images/new.xml
  def new
    @image = AzImage.new
    @image.az_design_id = params[:id]
    #perpare_images(@az_image)
    #@az_image.az_page_id = params[:az_page_id]

    respond_to do |format|
      format.html { render :template => '/az_images/new', :layout => "popup_iframe"}
      #format.xml  { render :xml => @az_image }
    end
  end

  # GET /az_images/1/edit
#  def edit
#    @az_image = AzImage.find(params[:id])
#  end

  def create
    design_id = Integer(params[:az_image][:az_design_id])
    @image = AzImage.new
    @image.image = params[:az_image][:image]
    @image.az_design_id = -design_id
    @image.owner_id = -design_id

    respond_to do |format|
      if @image.save
        puts "ok"
        format.html { render :template => "/az_images/show", :layout => "popup_iframe"}
        #format.xml  { render :xml => @image, :status => :created, :location => @image }
      else
        puts "error"
        puts "============================"
        @image.az_design_id = -@image.az_design_id
        format.html { render :template => "/az_images/new", :layout => "popup_iframe"}
      end
    end
  end

  # POST /az_images
  # POST /az_images.xml
#  def create1
#    puts '====================================================================='
#    puts params.inspect
#    puts request.inspect
#    @az_image = AzImage.new
#
#    #puts params[:qqfile].path
#
#    tmp_file_path = params[:qqfile]
#    if params[:qqfile].class == Tempfile
#      tmp_file_path = params[:qqfile].path
#
#      tmp_file_path = params[:qqfile].original_path
#      #puts params[:qqfile].to_s
#      puts '2====================================================================='
#    end
#
#    file_name = File.basename(tmp_file_path).gsub(/[^\w\.\-]/, '_')
#    tmp_dir = Dir.tmpdir()
#    tmp_file_name = tmp_dir + "/" + file_name
#    f = File.new(tmp_file_name, 'wb')
#    f.syswrite(request.raw_post)
#    f.close
#    @az_image.az_design_id = -Integer(params[:design_rnd])
#    @az_image.owner_id = -Integer(params[:design_rnd])
#    File.open(tmp_file_name) { |ff| @az_image.image = ff }
#    File.delete(tmp_file_name)
#
#    respond_to do |format|
#      if @az_image.save
#        puts "ok"
#        flash[:notice] = 'AzImage was successfully created.'
#        format.html { render :text => "{success:true}"}
#        format.xml  { render :xml => @az_image, :status => :created, :location => @az_image }
#      else
#        #format.html { render :text => "Ok" }
#        puts "error"
#        str = ""
#        if @az_image.errors.size > 0
#          str += "=================================================================="
#          @az_image.errors.each{|attr,msg| puts "#{attr} - #{msg}\n" }
#          str += "=================================================================="
#        end
#        return str
#        puts "============================"
#        format.html { render :text => "{success:false}"}
#        #format.html { render :partial => 'new_edit'}
#        #format.xml  { render :xml => @az_image.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /az_images/1
  # PUT /az_images/1.xml
#  def update
#    @az_image = AzImage.find(params[:id])
#
#    respond_to do |format|
#      if @az_image.update_attributes(params[:az_image])
#        flash[:notice] = 'AzImage was successfully updated.'
#        format.html { redirect_to(@az_image) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @az_image.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /az_images/1
  # DELETE /az_images/1.xml
#  def destroy
#    @az_image = AzImage.find(params[:id])
#    @az_image.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(az_images_url) }
#      format.xml  { head :ok }
#    end
#  end

  def destroy_by_rnd
    rnd = Integer(params[:rnd])
    @image = AzImage.find_by_az_design_id(-rnd)
    if @image == nil

    else
      @image.destroy
    end

    @image = AzImage.new
    @image.az_design_id = rnd

    respond_to do |format|
      format.html { render :template => "/az_images/new", :layout => "popup_iframe"}
      #format.xml  { head :ok }
    end
  end

end
