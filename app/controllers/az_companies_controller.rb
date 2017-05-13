class AzCompaniesController < ApplicationController
  
  filter_access_to :new, :create, :index, :index_ceo_note, :liqpay_result
  filter_access_to :all, :attribute_check => true

  layout "main"

  # GET /az_companies
  # GET /az_companies.xml
  def index
    @tariffs = AzTariff.all
    @tariffs = @tariffs.collect{|t| [t.name + " " + t.tariff_type.to_s, t.id]}

    @companies = AzCompany.paginate(:all, :page => params[:page], :order => 'id desc')

#    @seeds = {AzProject => {},
#              AzProjectBlock => {},
#              AzStructDataType => {},
#              AzDefinition => {},
#              AzCommonsAcceptanceCondition => {},
#              AzCommonsCommon => {},
#              AzCommonsContentCreation => {},
#              AzCommonsPurposeExploitation => {},
#              AzCommonsPurposeFunctional => {},
#              AzCommonsRequirementsHosting => {},
#              AzCommonsRequirementsReliability => {}}
#
#    @seeds.each_pair do |cls, cls_seeds_by_id|
#      cls_seeds = cls.find(:all, :conditions => "seed = 1")
#      cls_seeds.each do |item|
#        cls_seeds_by_id[item.id] = item
#      end
#    end

    #puts "(((((((((((((((((((((((((((((((((((((((((((("
    #puts @seeds.inspect

#    seed_projects = AzProject.find(:all, :conditions => "seed = 1")
#    @seed_projects_by_id = {}
#    seed_projects.each do |project|
#      @seed_projects_by_id[project.id] = project
#    end
#
#    seed_blocks = AzProjectBlock.find(:all, :conditions => "seed = 1")
#    @seed_blocks_by_id = {}
#    seed_blocks.each do |item|
#      @seed_blocks_by_id[item.id] = item
#    end
#
#    seeds = AzStructDataType.find(:all, :conditions => "seed = 1")
#    @seed_structs_by_id = {}
#    seeds.each do |seed|
#      @seed_structs_by_id[seed.id] = seed
#    end


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_companies }
    end
  end

  def waiting_payments
    @company = AzCompany.find(params[:id])
    @az_payments = AzPayment.find(:all, :conditions => {:az_company_id => @company.id, :status => 'started'})

    respond_to do |format|
      format.html {render :template => 'az_companies/waiting_payments', :locals => {}}
    end
  end

  def index_ceo_note
    @companies = AzCompany.paginate(:page => params[:page], :order => 'id desc')
  end

  # GET /az_companies/1
  # GET /az_companies/1.xml
  def show
    @az_company = AzCompany.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_company }
    end
  end

  def admin_show
    @az_company = AzCompany.find(params[:id])

    respond_to do |format|
      format.html {render :template => 'az_companies/admin/show'}
    end
  end

  # GET /az_companies/new
  # GET /az_companies/new.xml
  def new
    @az_company = AzCompany.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_company }
    end
  end

  # GET /az_companies/1/edit
  def edit
    @az_company = AzCompany.find(params[:id])
  end

  # POST /az_companies
  # POST /az_companies.xml
  def create
    @az_company = AzCompany.new(params[:az_company])
    #admin = AzUser.find_by_login('admin')
    user = @az_company.ceo
    #@az_company.ceo = admin
    ret = @az_company.save
    if ret

      if Integer(params[:az_company][:wo_ceo_co_create]) != 1
        @az_company.add_employee(user) 
      end

      if Integer(params[:az_company][:create_default_content_co_create]) == 1
        @az_company.create_default_content
      end
    end
    respond_to do |format|
      if ret
        flash[:notice] = 'AzCompany was successfully created.'
        format.html { redirect_to(@az_company) }
        format.xml  { render :xml => @az_company, :status => :created, :location => @az_company }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_company.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_companies/1
  # PUT /az_companies/1.xml
  def update
    @az_company = AzCompany.find(params[:id])

    respond_to do |format|
      if @az_company.update_attributes(params[:az_company]) #TODO Защитить баланс!!!
        flash[:notice] = 'AzCompany was successfully updated.'
        format.html { redirect_to(@az_company) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_company.errors, :status => :unprocessable_entity }
      end
    end
  end

  def user_update
    @az_company = AzCompany.find(params[:id])

    @az_company.name = params[:az_company][:name]
    @az_company.site = params[:az_company][:site]

    #puts params[:az_company][:ceo_id]
    new_ceo_id = Integer(params[:az_company][:ceo_id])
    #employees_wo_current = @az_company.az_employees.select{|e| e.az_user.id != @az_company.ceo_id }
    new_ceo = @az_company.az_employees.select{|e| e.az_user.id == new_ceo_id}

    #puts @az_company.az_employees.inspect
    #puts new_ceo.inspect

    ceo_changed = false

    if new_ceo.size == 0
      raise 'Invalid CEO_ID'
    elsif new_ceo[0].az_user.id != @az_company.ceo_id
      ceo_changed = true
      @az_company.ceo_id = new_ceo[0].az_user.id
    end
    
    @az_company.site = params[:az_company][:site]

    if params[:az_company][:logo]
      @az_company.logo = params[:az_company][:logo]
    end

    if params[:az_company][:delete_logo] && params[:az_company][:delete_logo] == '1'
      @az_company.logo.destroy
    end

    ret = @az_company.save

    if ceo_changed # Отправить на главную, т.к. к редактированию доступа уже нет.
      rp = '/'
    else
      rp = edit_az_company_path(@az_company)
    end

    respond_to do |format|
      if ret
        flash[:notice] = 'Успешно.'
        format.html { redirect_to(rp) }
      else
        format.html { render :template => "az_companies/edit" }
      end
    end

  end

  # DELETE /az_companies/1
  # DELETE /az_companies/1.xml
  def destroy
    @az_company = AzCompany.find(params[:id])
    @az_company.destroy

    respond_to do |format|
      format.html { redirect_to(:back) }
    end
  end

#  def make_payment
#    company = AzCompany.find(params[:id])
#    amount = params[:id]
#    payment = AzPayment.new
#    payment.az_company = company
#    payment.amount = amount
#    respond_to do |format|
#      format.html { render :template => 'az_companies/make_payment', :locals => {:payment => payment} }
#    end
#  end

  def pay
    company = AzCompany.find(params[:id])
    #if company.payment == nil || company.payment == 0
    #  return
    #end

    company.payment = Float(params[:az_company][:payment])

    payment = AzPayment.new
    payment.az_company = company
    payment.az_company = company.payment
#    company.transaction do
#      t = AzBalanceTransaction.new
#      t.az_company = company
#      t.amount = company.payment
#      t.description = 'Пополнение счета'
#      email = 'stg34@ua.fm, boris.mikhailenko@gmail.com'
#      begin
#        t.save!
#        MessageMailer.deliver_payment_message(email, company.name, company.id, t.description, t.amount, t.id)
#      rescue
#        MessageMailer.deliver_payment_message(email, company.name, company.id, t.description, t.amount, -1)
#      end
#    end

    operation_xml = Base64.encode64(create_liqpay_xml_request)
    merc_sign_xml_merc_sign = Merc_sign + create_liqpay_xml_request + Merc_sign
    signature = Base64.encode64(Digest::SHA1.digest(merc_sign_xml_merc_sign))

    company = AzCompany.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'az_companies/make_payment', :locals => {:company => company, :operation_xml => operation_xml, :signature => signature} }
    end

    respond_to do |format|
      format.html { render :template => 'az_companies/pay', :locals => {:company => company} }
    end
  end

  def payment_result
    #payment = AzCompany.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'az_companies/payment_result', :locals => {:company => 'company'} }
    end
  end


  def billing_history
    company = AzCompany.find(params[:id])
    balance_transactions = AzBalanceTransaction.paginate(:all, :conditions => {:az_company_id => company.id}, :order => 'id desc', :page => params[:page])
    respond_to do |format|
      format.html { render :template => 'az_companies/billing_history', :locals => {:company => company, :balance_transactions => balance_transactions} }
    end
  end

  def change_tariff
    tariff = AzTariff.find(:first)
    tariff.get_cost_from_moment_till_end_of_month(Time.now)
    puts "---------------------------------------------------------------------------"
    puts tariff.get_cost_from_moment_till_end_of_month(Time.now)
    company = AzCompany.find(params[:id])
    
    #tariffs = AzTariff.get_user_available_tariffs
    tariffs = AzTariff.get_future_tariffs

    available_tariffs = tariffs.collect{|t| [t.name, t.id]}
    respond_to do |format|
      format.html { render :template => 'az_companies/change_tariff', :locals => {:company => company, :tariffs => tariffs, :available_tariffs => available_tariffs} }
    end
  end

  def set_tariff
    company = AzCompany.find(params[:id])
    tariff = AzTariff.find(params[:az_company][:az_tariff_id])

    available_tariff_ids = AzTariff.get_user_available_tariffs.collect{|t| t.id}

    res = false
    if available_tariff_ids.include?(tariff.id)
      company.change_tariff(tariff)
      res = true
    end
    
    available_tariffs = AzTariff.get_user_available_tariffs.collect{|t| [t.name, t.id]}
    respond_to do |format|
      if res
        format.html { redirect_to :controller => 'az_profiles', :action => 'index' }
      else
        format.html { render :template => 'az_companies/change_tariff', :locals => {:company => company, :available_tariffs => available_tariffs} }
      end
      
    end
  end

  def select_company_dialog
    @companies = current_user.az_companies
    @project = AzProject.find(params[:item_id])
    respond_to do |format|
      format.html { render :partial => "select_company_dialog" }
    end
  end

end
