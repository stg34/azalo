class AzOperationTimesController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_operation_times
  # GET /az_operation_times.xml
  def index1
    @az_operation_times = AzOperationTime.find(:all, :order => :az_base_data_type_id)
    @az_operations = AzOperation.all

    @base_data_type_ids = @az_operation_times.collect{ |ot| ot.az_base_data_type_id }.sort!.uniq!

    @operations_ids = @az_operations.collect{ |op| op.id}
    @data_type_op_times = {}

    @az_operation_times.each do |opt|
      if @data_type_op_times[opt.az_base_data_type] == nil
        @data_type_op_times[opt.az_base_data_type] = {opt.az_operation_id => Float(opt.operation_time)}
      else
        @data_type_op_times[opt.az_base_data_type][opt.az_operation_id] = Float(opt.operation_time)
      end
    end

    puts "=================" + @base_data_type_ids.inspect
    puts @data_type_op_times.inspect
    #puts @az_operation_times.inspect

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_operation_times }
    end
  end

  # GET /az_operation_times
  # GET /az_operation_times.xml
  def index
    @az_operation_times = AzOperationTime.find(:all, :order => :az_base_data_type_id)
    @az_operations = AzOperation.all
    @simple_data_types = AzSimpleDataType.get_my_types

    @simple_data_types.each do |sdt|
      @az_operations.each do |op|
        opt = AzOperationTime.find(:first, :conditions => { :az_base_data_type_id => sdt.id, :az_operation_id => op.id })
        sdt[op] = opt
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_operation_times }
    end
  end



  # GET /az_operation_times/1
  # GET /az_operation_times/1.xml
#  def show
#    @az_operation_time = AzOperationTime.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @az_operation_time }
#    end
#  end

  # GET /az_operation_times/new
  # GET /az_operation_times/new.xml
  def new
    @az_operation_time = AzOperationTime.new
    @az_operations = AzOperation.all
   
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_operation_time }
    end
  end

  # GET /az_operation_times/1/edit
  def edit
    @az_operation_time = AzOperationTime.find(params[:id])
  end

  # POST /az_operation_times
  # POST /az_operation_times.xml
  def create
    @az_operation_time = AzOperationTime.new(params[:az_operation_time])


    # TODO fix owner_id
    @az_operation_time.owner_id = 2

    result = true

    operation_id = params[:az_operation_time][:az_operation_id]
    data_type_id = params[:az_operation_time][:az_base_data_type_id]


    @operation_times = AzOperationTime.find(:all, :conditions => {:az_operation_id => operation_id, :az_base_data_type_id => data_type_id})

    if @operation_times.size > 0
      @operation_times.each do |opt|
        opt.destroy
      end
    end
    
    @az_typed_page_operation = AzOperationTime.new(params[:az_operation_time])
    # TODO fix owner_id
    @az_typed_page_operation.owner_id = 2


    result = @az_typed_page_operation.save


    respond_to do |format|
      if result
        flash[:notice] = 'AzOperationTime was successfully created.'
        format.html { redirect_to(:controller => :az_operation_times, :action => :index) }
        format.xml  { render :xml => @az_operation_time, :status => :created, :location => @az_operation_time }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_operation_time.errors, :status => :unprocessable_entity }
      end
    end
  end
#
#  # PUT /az_operation_times/1
#  # PUT /az_operation_times/1.xml
#  def update
#    @az_operation_time = AzOperationTime.find(params[:id])
#
#    respond_to do |format|
#      if @az_operation_time.update_attributes(params[:az_operation_time])
#        flash[:notice] = 'AzOperationTime was successfully updated.'
#        format.html { redirect_to(@az_operation_time) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @az_operation_time.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /az_operation_times/1
#  # DELETE /az_operation_times/1.xml
#  def destroy
#    @az_operation_time = AzOperationTime.find(params[:id])
#    @az_operation_time.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(az_operation_times_url) }
#      format.xml  { head :ok }
#    end
#  end
end
