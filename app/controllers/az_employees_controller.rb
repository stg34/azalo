class AzEmployeesController < ApplicationController


  filter_access_to :all

  layout "main"

  # GET /az_employees
  # GET /az_employees.xml
  def index
    @az_employees = AzEmployee.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_employees }
    end
  end


  # GET /index_user
  def index_user

    @me = current_user
    @my_companies = current_user.az_companies
    @employees = AzEmployee.get_by_companies(@my_companies)

    @title = 'Работники'

    respond_to do |format|
      format.html # index.html.erb
    end
  end


#  # GET /az_employees/1
#  # GET /az_employees/1.xml
#  def show
#    @az_employee = AzEmployee.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @az_employee }
#    end
#  end
#
  # GET /az_employees/new
  # GET /az_employees/new.xml
#  def new
#    @az_employee = AzEmployee.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @az_employee }
#    end
#  end
#
#  # GET /az_employees/1/edit
#  def edit
#    @az_employee = AzEmployee.find(params[:id])
#  end
#
#  # POST /az_employees
#  # POST /az_employees.xml
#  def create
#    @az_employee = AzEmployee.new(params[:az_employee])
#
#    respond_to do |format|
#      if @az_employee.save
#        flash[:notice] = 'AzEmployee was successfully created.'
#        format.html { redirect_to(@az_employee) }
#        format.xml  { render :xml => @az_employee, :status => :created, :location => @az_employee }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @az_employee.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /az_employees/1
#  # PUT /az_employees/1.xml
#  def update
#    @az_employee = AzEmployee.find(params[:id])
#
#    respond_to do |format|
#      if @az_employee.update_attributes(params[:az_employee])
#        flash[:notice] = 'AzEmployee was successfully updated.'
#        format.html { redirect_to(@az_employee) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @az_employee.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /az_employees/1
  # DELETE /az_employees/1.xml
  # def destroy
  #   employee = AzEmployee.find(params[:id])
  #   employee.az_company.delete_employee1(employee)
    
  #   respond_to do |format|
  #     format.html { redirect_to(:action => 'index_user') }
  #   end
  # end

  def dismiss
    employee = AzEmployee.find(params[:id])
    employee.az_company.delete_employee(employee)

    respond_to do |format|
      format.html { redirect_to(:action => 'index_user') }
    end
  end

  def enable
    @az_employee = AzEmployee.find(params[:id])
    @az_employee.enable

    respond_to do |format|
      format.html { redirect_to(:action => 'index_user') }
    end
  end

  def disable
    @az_employee = AzEmployee.find(params[:id])
    @az_employee.disable

    respond_to do |format|
      format.html { redirect_to(:action => 'index_user') }
    end
  end
end
