class AzTypedPagesController < ApplicationController

  filter_access_to :all

  layout "main"
  
  def index
    @az_pages_types = AzTypedPage.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_tasks }
    end
  end

  def show

  end

  # GET /az_typed_pages/1
  # GET /az_typed_pages/1.xml
  def show
    @az_page_type = AzTypedPage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_page_type }
    end
  end

  def new
  end

  # PUT /az_typed_pages/1
  # PUT /az_typed_pages/1.xml
  def update
    @tp = AzTypedPage.find(params[:id])

    respond_to do |format|
      if @tp.update_attributes(params[:az_typed_page])
        flash[:notice] = 'Успешно сохранено.'
        format.html { redirect_to(edit_az_typed_page_path(@tp)) }
        format.xml  { head :ok }
      else
        prepare_default_data()
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_operations
    @tp = AzTypedPage.find(params[:id])

    tp_op_ids = @tp.az_allowed_operations.collect{|op| op.az_operation.id }

    op_ids = []
    if params[:operations]
      params[:operations].each_key do |op_id|
        op_ids << Integer(op_id)
      end
    end

    #operations = AzOperation.find(:all)

    ops_to_add = op_ids - tp_op_ids
    ops_to_remove = tp_op_ids - op_ids
    #puts "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    #puts ops_to_add.inspect
    #puts ops_to_remove.inspect
    #puts "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

    ops_to_add.each do |op_id|
      op = AzAllowedOperation.new
      op.az_typed_page = @tp
      op.az_operation_id = op_id
      op.owner = @tp.az_page.owner
      op.save!
    end

    ops_to_remove.each do |op_id|
      #op = AzAllowedOperation.find(:all, op_id)
      ops = AzAllowedOperation.find(:all, :conditions => {:az_typed_page_id => @tp.id, :az_operation_id => op_id})
      ops.each do |op|
        op.destroy
      end
    end

    respond_to do |format|
      if true #@tp.update_attributes(params[:az_typed_page])
        flash[:notice] = 'Успешно сохранено.'
        format.html { render :text => "Ok" }
        #format.html { render :text => "Успешно. Подождите...<script type='text/javascript'>reload_page(#{@tp.az_page.id});</script>" }
        #format.xml  { head :ok }
      else
        #prepare_default_data()
        format.html { render :text => "Успешно. Подождите...<script type='text/javascript'>reload_page(#{@tp.az_page.id});</script>" }
        #format.xml  { render :xml => @az_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @az_page_type = AzTypedPage.find(params[:id])
  end

  # DELETE /az_page_types/1
  # DELETE /az_page_types/1.xml
  def destroy
    @az_page_type = AzTypedPage.find(params[:id])
    @az_page_type.destroy

    respond_to do |format|
      format.html { redirect_to(az_page_types_url) }
      format.xml  { head :ok }
    end
  end

  def operations_dialog
    typed_page = AzTypedPage.find(params[:id])
    operations = AzOperation.find(:all)
    respond_to do |format|
      format.html { render :partial => "helpers/page_operations_dialog", :locals => {:typed_page => typed_page, :operations => operations} }
    end
  end
  

end
