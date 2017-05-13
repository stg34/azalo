class AzProjectBlocksController < AzBaseProjectsController

  filter_access_to :index_user, :new, :create, :index, :components_dialog
  filter_access_to :all, :attribute_check => true

  layout "main"

  # GET /az_project_blocks
  # GET /az_project_blocks.xml
  def index
    @az_project_blocks = AzProjectBlock.paginate(:all, :conditions => {:copy_of => nil}, :page => params[:page], :order => 'id desc')

    @title = 'Компоненты сайтов'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_project_blocks }
    end
  end

  # GET /az_project_blocks
  # GET /az_project_blocks.xml
  def index_user
    @my_companies = current_user.my_works
    @project_blocks = AzProjectBlock.get_by_companies(@my_companies)
    @title = 'Компоненты сайтов'
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @show_type = show_type_str_to_sym(params[:show_type])
    @project = AzProjectBlock.find(params[:id])

    # f0 = File.open(Rails.root + "tmp/cmp-#{@project.id}", "w")
    # project_hash = @project.to_az_hash
    # f0.write(project_hash.to_yaml)
    # f0.close

    @all_data_types = AzBaseDataType.find_all_by_az_base_project_id(@project.id)
    @data_type_list_with_collections = AzPageType.page_types_with_collections(@all_data_types)
    @definitions = @project.get_definitions

    @project_tree = PrTree.build(@project)

    @title = 'Компонент "' + @project.name + '"'

    respond_to do |format|
      format.html { render :template => 'az_base_projects/show1'}
      format.xml  { render :xml => @project }
    end
  end

  def show_tr
    @project = AzProjectBlock.find(params[:id])
    @project.get_data_types

    @data_types = AzBaseDataType.find_all_by_az_base_project_id(@project.id)

    @definitions = []
    @definitions.concat(@project.az_definitions) if @project.az_definitions.size > 0
    
    @validators = get_validators_from_data_types(@data_types)

    @title = 'ТЗ на "' + @project.name + '"'
    respond_to do |format|
      format.html { render :template => 'az_base_projects/tr/show'}
    end
  end

  def summary
    @project = AzProjectBlock.find(params[:id])
    @all_pages = @project.get_full_pages_list.sort{|a, b| a.page_type<=>b.page_type }
    @tasks = AzTask.find(:all)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @project.to_xml }
    end
  end

  # GET /az_project_blocks/new
  # GET /az_project_blocks/new.xml
  def new
    @az_project_block = AzProjectBlock.new

    @az_project_block.owner_id = params[:owner_id]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_project_block }
    end
  end

  # GET /az_project_blocks/1/edit
  def edit
    @project_block = AzProjectBlock.find(params[:id])
    @company = AzCompany.find(@project_block.owner_id)
    @definitions = AzDefinition.get_by_company(@company)
    @title = 'Свойства компонента "' + @project_block.name + '"'
  end

  # POST /az_project_blocks
  # POST /az_project_blocks.xml
  def create
    cmp = AzCompany.find(params[:az_project_block][:owner_id])
    @az_project_block = AzProjectBlock.create(params[:az_project_block][:name], cmp, current_user)

    respond_to do |format|
      if @az_project_block.save
        flash[:notice] = 'Компонент успешно создан.'
        format.html { redirect_to(@az_project_block) }
        format.xml  { render :xml => @az_project_block, :status => :created, :location => @az_project_block }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_project_block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_project_blocks/1
  # PUT /az_project_blocks/1.xml
  def update
    @az_project_block = AzProjectBlock.find(params[:id])

    respond_to do |format|
      if @az_project_block.update_attributes(params[:az_project_block])
        flash[:notice] = 'Компонент успешно изменен.'
        format.html { redirect_to(@az_project_block) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_project_block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_project_blocks/1
  # DELETE /az_project_blocks/1.xml
  def destroy
    @az_project_block = AzProjectBlock.find(params[:id])
    @az_project_block.deleting = true # По этому странному атрибуту страница определяет, что она не должна удалять свои задачи из Redmine
    @az_project_block.save
    @az_project_block.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'index_user') }
      format.xml  { head :ok }
    end
  end

  def change_definitions
    # TODO az_project имеет такой же самый метод!!!
    project = AzProjectBlock.find(params[:id])
    definition_ids = []

    #params.select{|param| param[0].index('definition_') == 0 }

    params.each do |param|
      puts param[0].inspect
      if param[0].index('definition_') == 0
        definition_ids << Integer(param[1])
      end
    end

    project.change_definitions(definition_ids)

    respond_to do |format|
      format.html { redirect_to(project) }
    end

  end

  def copy
    project = AzProjectBlock.find(params[:id])
    company = AzCompany.find(params[:owner_id])
    project.make_copy(company)
    respond_to do |format|
      format.html { redirect_to('/components') }
    end
  end

  def move_up
    move_higher(AzProjectBlock.find(params[:id]))
  end

  def move_down
    move_lower(AzProjectBlock.find(params[:id]))
  end

  def components_dialog
    project_id = params[:id]
    project = AzProject.find(project_id)
    my_companies = current_user.my_works
    components = []
    if my_companies.include?(project.owner)
        components = AzProjectBlock.get_by_company(project.owner)
    end

    respond_to do |format|
      format.html { render(:partial => '/az_project_blocks/components_dialog', :locals => {:components => components, :project => project})}
    end
  end

end
