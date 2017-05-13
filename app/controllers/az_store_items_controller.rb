class AzStoreItemsController < ApplicationController

  filter_access_to :index, :new, :create, :not_enough_money_dialog
  filter_access_to :all, :attribute_check => true

  layout "main"

  # GET /az_store_items
  # GET /az_store_items.xml
  def index
    @az_store_items = AzStoreItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_store_items }
    end
  end

  # GET /az_store_items/1
  # GET /az_store_items/1.xml
  def show

    @az_store_item = AzStoreItem.find(params[:id])

    if @az_store_item.item.class == AzProjectBlock
      @title = "Компонент технического задания на сайт '#{@az_store_item.item.name.downcase}'"
    else
      @title = "Техническое задание на сайт '#{@az_store_item.item.name.downcase}'"
    end

    project = AzBaseProject.find(@az_store_item.item.id)
    @project_tree = PrTree.build(project)

    @public_pages = []
    @admin_pages = []

    @project_tree.walk_public_subtree do |node|
      @public_pages << node.main_page
    end

    @project_tree.walk_admin_subtree do |node|
      @admin_pages << node.main_page
    end

    respond_to do |format|
      format.html # show.html.erb
      #format.xml  { render :xml => @az_store_item }
    end
  end

  # GET /az_store_items/new
  # GET /az_store_items/new.xml
  def new
    @az_store_item = AzStoreItem.new
    @az_store_item.az_store_item_scetches << AzStoreItemScetch.new
    @az_store_item.az_store_item_scetches << AzStoreItemScetch.new
    @az_store_item.az_store_item_scetches << AzStoreItemScetch.new
    @languages = AzLanguage.find(:all)
    @scetch_programs = AzScetchProgram.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_store_item }
    end
  end

  # GET /az_store_items/1/edit
  def edit
    @languages = AzLanguage.find(:all)
    @scetch_programs = AzScetchProgram.find(:all)
    @az_store_item = AzStoreItem.find(params[:id])

    n = 3 - @az_store_item.az_store_item_scetches.size
    puts "==========================================="
    puts n
    n.times do
      @az_store_item.az_store_item_scetches.build# << AzStoreItemScetch.new
    end

  end

  # POST /az_store_items
  # POST /az_store_items.xml
  def create
    @az_store_item = AzStoreItem.new(params[:az_store_item])
    @scetch_programs = AzScetchProgram.find(:all)
    @languages = AzLanguage.find(:all)

    respond_to do |format|
      if @az_store_item.save
        format.html { redirect_to(@az_store_item, :notice => 'AzStoreItem was successfully created.') }
        format.xml  { render :xml => @az_store_item, :status => :created, :location => @az_store_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_store_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_store_items/1
  # PUT /az_store_items/1.xml
  def update
    @az_store_item = AzStoreItem.find(params[:id])
    @scetch_programs = AzScetchProgram.find(:all)
    @languages = AzLanguage.find(:all)

    respond_to do |format|
      if @az_store_item.update_attributes(params[:az_store_item])
        format.html { redirect_to(edit_az_store_item_path(@az_store_item), :notice => 'AzStoreItem was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_store_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_store_items/1
  # DELETE /az_store_items/1.xml
  def destroy
    @az_store_item = AzStoreItem.find(params[:id])
    @az_store_item.destroy

    respond_to do |format|
      format.html { redirect_to(az_store_items_url) }
      format.xml  { head :ok }
    end
  end

  def buy
    #company_ids = current_user.az_companies.collect{|c| c.id}
    store_item = AzStoreItem.find(params[:id])
    company = AzCompany.find(params[:company_id])
    company.get_balance
    ret = false
    if company.ceo_id == current_user.id
      puts "----------------- OK -------------------"
      ret = store_item.buy(company)
      puts ret
    else
      puts "----------------- ERROR -------------------"
    end

    item_controller = store_item.item_type.tableize
    respond_to do |format|
      if ret 
        format.html { redirect_to({:controller => item_controller, :action => 'show', :id => ret})  }
      else
        format.html { render :text => "Error" }
      end
      
    end
  end

  def select_company_dialog
    @companies = current_user.az_companies
    @az_store_item = AzStoreItem.find(params[:id])
    respond_to do |format|
      format.html { render :partial => "az_store_items/select_company_dialog" }
    end
  end

  def not_enough_money_dialog
    @store_item = AzStoreItem.find(params[:id])
    @company = current_user.az_companies[0]
    respond_to do |format|
      format.html { render :partial => "az_store_items/not_enough_money_dialog" }
    end
  end
end
