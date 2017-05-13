class AzPageAzProjectBlocksController < ApplicationController
  # GET /az_page_az_project_blocks
  # GET /az_page_az_project_blocks.xml
  def index
    @az_page_az_project_blocks = AzPageAzProjectBlock.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_page_az_project_blocks }
    end
  end

  # GET /az_page_az_project_blocks/1
  # GET /az_page_az_project_blocks/1.xml
  def show
    @az_page_az_project_block = AzPageAzProjectBlock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_page_az_project_block }
    end
  end

  # GET /az_page_az_project_blocks/new
  # GET /az_page_az_project_blocks/new.xml
  def new
    @az_page_az_project_block = AzPageAzProjectBlock.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_page_az_project_block }
    end
  end

  # GET /az_page_az_project_blocks/1/edit
  def edit
    @az_page_az_project_block = AzPageAzProjectBlock.find(params[:id])
  end

  # POST /az_page_az_project_blocks
  # POST /az_page_az_project_blocks.xml
  def create
    @az_page_az_project_block = AzPageAzProjectBlock.new(params[:az_page_az_project_block])

    respond_to do |format|
      if @az_page_az_project_block.save
        flash[:notice] = 'AzPageAzProjectBlock was successfully created.'
        format.html { redirect_to(@az_page_az_project_block) }
        format.xml  { render :xml => @az_page_az_project_block, :status => :created, :location => @az_page_az_project_block }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_page_az_project_block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_page_az_project_blocks/1
  # PUT /az_page_az_project_blocks/1.xml
  def update
    @az_page_az_project_block = AzPageAzProjectBlock.find(params[:id])

    respond_to do |format|
      if @az_page_az_project_block.update_attributes(params[:az_page_az_project_block])
        flash[:notice] = 'AzPageAzProjectBlock was successfully updated.'
        format.html { redirect_to(@az_page_az_project_block) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_page_az_project_block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_page_az_project_blocks/1
  # DELETE /az_page_az_project_blocks/1.xml
  def destroy
    @az_page_az_project_block = AzPageAzProjectBlock.find(params[:id])
    @az_page_az_project_block.destroy

    respond_to do |format|
      format.html { redirect_to(az_page_az_project_blocks_url) }
      format.xml  { head :ok }
    end
  end
end
