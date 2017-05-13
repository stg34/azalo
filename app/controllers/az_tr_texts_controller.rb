class AzTrTextsController < ApplicationController

  filter_access_to :index_user, :new, :create
  filter_access_to :all, :attribute_check => true

  layout "main"

  # GET /az_tr_texts
  # GET /az_tr_texts.xml
  def index
    @az_tr_texts = AzTrText.all
    prepare_default_data()

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_tr_texts }
    end
  end

  def index_user
    @my_companies = current_user.my_works
    tr_texts_by_companies = AzTrText.get_by_companies(@my_companies)
    @title = 'Тексты ТЗ'
    @tr_text_types = [:struct, :collection, :other]

    @tr_text_type_names = {}
    @tr_text_type_names[:struct] = "Тексты для структур данных"
    @tr_text_type_names[:collection] = "Тексты для коллекций данных"
    @tr_text_type_names[:other] = "Тексты не связанные с типами данных"



    @tr_texts = {}

    tr_texts_by_companies.each_pair do |company, tr_texts|
      @tr_texts[company] = {}
      @tr_texts[company][:struct] = tr_texts.select{|t| t.data_type == AzBaseDataType::StructTypeId}
      @tr_texts[company][:collection] = tr_texts.select{|t| t.data_type == AzBaseDataType::CollectionTypeId}
      @tr_texts[company][:other] = tr_texts.select{|t| t.data_type != AzBaseDataType::StructTypeId && t.data_type != AzBaseDataType::CollectionTypeId}
    end

    prepare_default_data()

    node, struct, operation, collection = AzTrText.create_show_content

    @tr_text_data_types = {}
    @tr_text_data_types[:struct] = struct
    @tr_text_data_types[:collection] = collection
    @tr_text_data_types[:other] = struct

    respond_to do |format|
      format.html { render :template => 'az_tr_texts/index_user', :locals => { :node => node, :struct => struct, :operation => operation, :collection => collection }}
      #format.xml  { render :xml => @az_definitions }
    end
  end

  # GET /az_tr_texts/1
  # GET /az_tr_texts/1.xml
  def show
    @az_tr_text = AzTrText.find(params[:id])
    node, struct, operation, collection = AzTrText.create_show_content
    @title = 'Шаблон текста технического задания "' + @az_tr_text.name + '"'

    respond_to do |format|
      format.html { render :template => 'az_tr_texts/show', :locals => { :node => node, :struct => struct, :operation => operation, :collection => collection }}
      format.xml  { render :xml => @az_tr_text }
    end
  end

  # GET /az_tr_texts/new
  # GET /az_tr_texts/new.xml
  def new
    @az_tr_text = AzTrText.new
    @az_tr_text.owner_id = params[:owner_id]
    @title = 'Новый шаблон текста технического задания'

    prepare_default_data()
    
    #@data_types = AzBaseDataType::DataTypes.collect{|dt| puts dt.inspect}
    #[dt[:name], dt[:id]]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_tr_text }
    end
  end

  # GET /az_tr_texts/1/edit
  def edit
    prepare_default_data()
    @az_tr_text = AzTrText.find(params[:id])
    @title = 'Шаблон текста технического задания "' + @az_tr_text.name + '"'
  end

  # POST /az_tr_texts
  # POST /az_tr_texts.xml
  def create
    @az_tr_text = AzTrText.new(params[:az_tr_text])
    @title = 'Новый шаблон текста технического задания'

    respond_to do |format|
      if @az_tr_text.save
        format.html { redirect_to(@az_tr_text, :notice => 'Шаблон текста успешно создан.') }
        format.xml  { render :xml => @az_tr_text, :status => :created, :location => @az_tr_text }
      else
        prepare_default_data()
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_tr_text.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_tr_texts/1
  # PUT /az_tr_texts/1.xml
  def update
    @az_tr_text = AzTrText.find(params[:id])
    @title = 'Шаблон текста технического задания "' + @az_tr_text.name + '"'

    respond_to do |format|
      if @az_tr_text.update_attributes(params[:az_tr_text])
        format.html { redirect_to(@az_tr_text, :notice => 'Шаблон текста успешно изменен.') }
        format.xml  { head :ok }
      else
        prepare_default_data()
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_tr_text.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_tr_texts/1
  # DELETE /az_tr_texts/1.xml
  def destroy
    @az_tr_text = AzTrText.find(params[:id])
    @az_tr_text.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'index_user') }
    end
  end

  def prepare_default_data
    @data_types = []
    AzBaseDataType::DataTypes.each_key{|k| @data_types << [AzBaseDataType::DataTypes[k][:name], AzBaseDataType::DataTypes[k][:id]]}

    operations = AzOperation.find(:all)
    @operations = operations.collect{|op| [op.name, op.id]}
    
    @operations_by_id = {}
    operations.each{|op| @operations_by_id[op.id] = op.name}

    @data_types_by_id = {}
    AzBaseDataType::DataTypes.each_pair{|key, value| @data_types_by_id[value[:id]] = value[:name]}    
    #puts '----------------------'
    #puts @data_types_by_id.inspect
  end


end
