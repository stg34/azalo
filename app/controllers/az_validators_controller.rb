class AzValidatorsController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_validators
  # GET /az_validators.xml
  def index
    @az_validators = AzValidator.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_validators }
    end
  end


  def index_user

    @my_companies = current_user.my_works
    @validators = AzValidator.get_by_companies(@my_companies)

    @title = 'Валидаторы'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_validators }
    end
  end

  # GET /az_validators/1
  # GET /az_validators/1.xml
  def show
    @az_validator = AzValidator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_validator }
    end
  end

  # GET /az_validators/new
  # GET /az_validators/new.xml
  def new
    @az_validator = AzValidator.new

    @az_validator.owner_id = params[:owner_id]
    if params[:az_variable_id]
      @az_validator.az_variable = AzVariable.find(params[:az_variable_id])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_validator }
    end
  end

  # GET /az_validators/1/edit
  def edit
    @az_validator = AzValidator.find(params[:id])
  end

  # POST /az_validators
  # POST /az_validators.xml
  def create
    @az_validator = AzValidator.new(params[:az_validator])

    respond_to do |format|
      if @az_validator.save
        flash[:notice] = 'Валидатор успешно создан.'
        if @az_validator.az_variable != nil && @az_validator.az_variable.az_struct_data_type != nil
          format.html { redirect_to(edit_az_struct_data_type_path(@az_validator.az_variable.az_struct_data_type)) }
        else
          format.html { redirect_to(@az_validator) }
        end
        
        format.xml  { render :xml => @az_validator, :status => :created, :location => @az_validator }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_validator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_validators/1
  # PUT /az_validators/1.xml
  def update
    @az_validator = AzValidator.find(params[:id])

    respond_to do |format|
      if @az_validator.update_attributes(params[:az_validator])
        flash[:notice] = 'Валидатор успешно изменен.'
        if @az_validator.az_variable != nil && @az_validator.az_variable.az_struct_data_type != nil
          format.html { redirect_to(edit_az_struct_data_type_path(@az_validator.az_variable.az_struct_data_type)) }
        else
          format.html { redirect_to(@az_validator) }
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_validator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_validators/1
  # DELETE /az_validators/1.xml
  def destroy
    @az_validator = AzValidator.find(params[:id])
    @az_validator.destroy

    respond_to do |format|
      format.html { redirect_to('/validators') }
      format.xml  { head :ok }
    end
  end
end
