class AzCImagesController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_c_images
  # GET /az_c_images.xml
  def index
    @az_c_images = AzCImage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_c_images }
    end
  end

  # GET /az_c_images/1
  # GET /az_c_images/1.xml
  def show
    @az_c_image = AzCImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_c_image }
    end
  end

  # GET /az_c_images/new
  # GET /az_c_images/new.xml
  def new
    @az_c_image = AzCImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_c_image }
    end
  end

  # GET /az_c_images/1/edit
  def edit
    @az_c_image = AzCImage.find(params[:id])
  end

  # POST /az_c_images
  # POST /az_c_images.xml
  def create
    @az_c_image = AzCImage.new(params[:az_c_image])

    respond_to do |format|
      if @az_c_image.save
        format.html { redirect_to(@az_c_image, :notice => 'AzCImage was successfully created.') }
        format.xml  { render :xml => @az_c_image, :status => :created, :location => @az_c_image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_c_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_c_images/1
  # PUT /az_c_images/1.xml
  def update
    @az_c_image = AzCImage.find(params[:id])

    respond_to do |format|
      if @az_c_image.update_attributes(params[:az_c_image])
        format.html { redirect_to(@az_c_image, :notice => 'AzCImage was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_c_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_c_images/1
  # DELETE /az_c_images/1.xml
  def destroy
    @az_c_image = AzCImage.find(params[:id])
    @az_c_image.destroy

    respond_to do |format|
      format.html { redirect_to(az_c_images_url) }
      format.xml  { head :ok }
    end
  end
end
