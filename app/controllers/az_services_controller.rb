class AzServicesController < ApplicationController

  filter_access_to :all
  
  layout "main"

  Simple_type_names = {'integer' => 'целое',
                       'float' => 'вещественное',
                       'string' => 'строка',
                       'text' => 'текст',
                       'boolean' => 'логическое',
                       'image' => 'изображение',
                       'blob' => 'двоичные данные',
                       'date' => 'дата',
                       'time' => 'время',
                       'datetime' => 'время и дата'}

  Operation_names = {'create' => 'создание',
                     'show' => 'отображение',
                     'update' => 'обновление',
                     'delete' => 'удаление',
                     'sort' => 'сортировака',
                     'paginate' => 'разбивка на страницы',
                     'search' => 'поиск'}


  Role_names =      {'manager' => 'менеджер',
                     'developer' => 'программист',
                     'layouter' => 'верстальщик',
                     'tester' => 'тестировщик'}
  

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def tables_size
    table_list = ActiveRecord::Base.connection.execute('show tables')
    @tables = {}
    table_list.each do |table|
      table_size = ActiveRecord::Base.connection.execute("select count(*) from #{table}")
      puts table_size.inspect
      #puts table_size.inspect
      table_size.each_hash{ |res| res.each_value {|v| @tables[table] = Integer(v)} }
    end

    respond_to do |format|
      format.html { render('tables_size') }
    end
  end

  def clean_table
    ActiveRecord::Base.connection.execute("delete from #{params[:id]}")
    respond_to do |format|
      format.html { redirect_to(:action => 'tables_size', :id=>1) }
    end
  end
  
  def create_simple_data_types
    Simple_type_names.each_value do |name|
      if AzSimpleDataType.find_by_name(name) == nil
        t = AzSimpleDataType.create(:name => name)
        t.save
      end
    end
    respond_to do |format|
      format.html { redirect_to(az_simple_data_types_path) }
    end

  end

  def create_operations
    #names = ['создание', 'отображение', 'обновление', 'удаление', 'сортировака', 'разбивка на страницы', 'поиск']
    Operation_names.each_value do |name|
      if AzOperation.find_by_name(name) == nil
        t = AzOperation.create(:name => name)
        t.save
      end
    end
    respond_to do |format|
      format.html { redirect_to(az_operations_url) }
    end
  end

  private
  def create_project_pages(pages, project_id, parent_id)
    pages.each_pair do |name, params|
      page = AzPage.new(:name => params[:name],
      :az_base_project_id => project_id,
      :position => params[:position],
      :parent_id => parent_id,
      :page_type => params[:page_type],
      :description => params[:description])
      page.save!

      params[:data_types].each_pair do |data_type, operations|
        tp = AzTypedPage.new(:az_page_id => page.id, :az_base_data_type_id => data_type.id)
        tp.save!

        operations.each do |operation_name|
          operation = AzOperation.find_by_name(Operation_names[operation_name])
          aop = AzAllowedOperation.new(:az_typed_page_id => tp.id, :az_operation_id => operation.id)
          aop.save!
        end
      end

      if params[:children] != nil
        create_project_pages(params[:children], project_id, page.id)
      end

    end

  end


  public
  def create_operations_time


    Simple_type_names.each_value do |tp_name|
      simple_type = AzSimpleDataType.find_by_name(tp_name)

      Operation_names.each_value do |op_name|
        operation = AzOperation.find_by_name(op_name)
        opt = AzOperationTime.new(:az_base_data_type_id => simple_type.id, :az_operation_id => operation.id, :operation_time => 1.0)
        opt.save!
      end
    end

    respond_to do |format|
      format.html { redirect_to(az_simple_data_types_path) }
    end
  end

  def update_from_seeds

    if params[:id] == nil
      companies = AzCompany.all
    else
      companies = [AzCompany.find(params[:id])]
    end
    
    @update_result = {}
    companies.each do |c|
      if c.ceo.login != 'seeder' # Пропускаем и ничего не обновляем у хозяина рассады
        remove_result = c.remove_default_content
        create_result = c.create_default_content(true)
        @update_result[c] = [remove_result, create_result]
      end
    end

    respond_to do |format|
      format.html { render :template => 'az_services/update_seeds_result'}
    end
  end

  def su

    if current_user.roles.include?(:admin)
      user = AzUser.find_by_email(params[:user])
      unless user
        user = AzUser.find_by_login(params[:user])
      end
    else
      user = nil
    end
    
    if user == nil
      redirect_path = '/az_services'
      flash[:notice] = 'Превращение не удалось.'
    else
      self.current_user = user
      redirect_path = '/dashboard'
      flash[:notice] = 'Теперь вы ' + user.login
    end
    respond_to do |format|
      format.html { redirect_to(redirect_path) }
    end
  end

  def make_copy_all

    error = false

    entity_class = AzProject
    redirect_path = '/projects'
    if params[:entity] == 'component'
      entity_class = AzProjectBlock
      redirect_path = '/components'
    end

    puts params[:entity]

    begin
      from_user = AzUser.find(Integer(params[:from_user]))
    rescue
      from_user = AzUser.find_by_login(params[:from_user])
    end

    begin
      to_user = AzUser.find(Integer(params[:to_user]))
    rescue
      to_user = AzUser.find_by_login(params[:to_user])
    end

    if from_user == nil
      flash[:notice] = "from_user (#{params[:from_user]}) not found"
      error = true
    end

    if to_user == nil
      flash[:notice] = "to_user (#{params[:to_user]}) not found"
      error = true
    end

    #puts params[:entity_id]
    #puts params[:from_user]
    #puts params[:to_user]

    #entity = entity_class.find(params[:entity_id])

    entities = entity_class.get_by_company(from_user.az_companies[0])

    entities.each do |e|
      e.make_copy(to_user.az_companies[0])
    end

    respond_to do |format|
      if error
        format.html { redirect_to('/az_services') }
      else
        format.html { redirect_to(redirect_path) }
      end
    end

  end


  def make_copy

    error = false

    entity_class = AzProject
    redirect_path = '/projects'
    restore_project = false

    puts "======================================================================================================="
    puts params[:id]
    puts params[:to_user]
    puts params[:make_component]
    puts "======================================================================================================="

    begin
      entity = AzProject.find(Integer(params[:id]))
      if params[:make_component]
        entity.type='AzProjectBlock'
        entity.save
        redirect_path = '/components'
        entity = AzProjectBlock.find(Integer(params[:id]))
        restore_project = true
      end
    rescue
      entity = AzProjectBlock.find(Integer(params[:id]))
      redirect_path = '/components'
    end

    if entity == nil
      error = true
      flash[:notice] = "project or component with id = (#{params[:id]}) not found"
    end

    begin
      to_user = AzUser.find(Integer(params[:to_user]))
    rescue
      to_user = AzUser.find_by_login(params[:to_user])
    end

    if to_user == nil
      flash[:notice] = "to_user (#{params[:to_user]}) not found"
      error = true
    end
    
    entity.make_copy(to_user.az_companies[0])

    if restore_project == true
      entity.type='AzProject'
      entity.save
    end

    respond_to do |format|
      if error
        format.html { redirect_to('/az_services') }
      else
        format.html { redirect_to(redirect_path) }
      end
    end

  end

#  def create_create_business_card_site
#    u = AzUser.create(:login => 'tim', :name => 'Timothy', :lastname=>'Berners-Lee' ,:email => 'tim@web.org', :password => '1d58990058212f41ad41918fd7f32', :password_confirmation => '1d58990058212f41ad41918fd7f32', :roles => (['nobody'] || []).map {|r| r.to_sym})
#    u.save!
#    respond_to do |format|
#      format.html { redirect_to(az_users_url) }
#    end
#  end

  def update_validators_from_seed
    #update_entity_from_seed(AzValidator)
    puts "============================================================="
    puts params[:id]

    sv = AzValidator.find(params[:id])
    if sv == nil
      return
    end
    puts sv.inspect
    res = ActiveRecord::Base.connection.execute("update az_validators set name = '#{sv.name}', description = '#{sv.description}', message = '#{sv.message}' where copy_of=#{params[:id]}")
    #puts res.inspect

    all_companies = AzCompany.find(:all)
    all_companies.each do |cmp|
      puts cmp.id
      c = AzCompany.find(cmp.id, :include => :az_validators)
      if c.ceo.never_visited == true
        puts "#{c.name}. CEO #{c.ceo.login} never visited"
      else
        if !c.az_validators.collect{|v| v.copy_of}.include?(sv.id)
          puts "sv.make_copy(c) ------------------------------ ceo: #{c.ceo.login}"
          sv.make_copy(c, nil)
        end
      end
    end

    sql = "select az_companies.id from az_companies
          left outer join az_validators on az_companies.id = az_validators.owner_id and az_validators.copy_of=#{params[:id]}
          where (az_companies.id < 5 and az_validators.id is NULL)"

    #res = ActiveRecord::Base.connection.execute(sql)

    #puts res.inspect
    #puts res.num_rows.inspect
    #puts res.fetch_row.inspect


    @update_result = {}
    respond_to do |format|
      format.html { render :template => '/az_services/result_update_seeds'}
    end
  end

  def update_definitions_from_seed
    puts "============================================================="
    puts params[:id]

    sd = AzDefinition.find(params[:id])
    if sd == nil
      return
    end
    puts sd.inspect
    res = ActiveRecord::Base.connection.execute("update az_definitions set name = '#{sd.name}', definition = '#{sd.definition}'' where copy_of=#{params[:id]}")
    #puts res.inspect

    all_companies = AzCompany.find(:all)
    all_companies.each do |cmp|
      puts cmp.id
      c = AzCompany.find(cmp.id, :include => :definitions)
      if c.ceo.never_visited == true
        puts "#{c.name}. CEO #{c.ceo.login} never visited"
      else
        if !c.definitions.collect{|v| v.copy_of}.include?(sd.id)
          puts "sv.make_copy(c) ------------------------------ ceo: #{c.ceo.login}"
          sd.make_copy(c, nil)
        end
      end
    end

    @update_result = {}
    respond_to do |format|
      format.html { render :template => '/az_services/result_update_seeds'}
    end
  end

  def update_tasks_from_seed
    update_entity_from_seed(AzTask)
  end

  def update_az_common_from_seed
    update_entity_from_seed(AzCommon)
  end

  def update_az_project_from_seed
    update_entity_from_seed(AzProject)
  end

  def update_az_project_block_from_seed
    update_entity_from_seed(AzProjectBlock)
  end

  def delete_seeded_project_blocks

    @remove_result = {}

    copy_of = Integer(params[:id])
    blocks = AzProjectBlock.find_all_by_copy_of(copy_of)
    blocks.each do |block|
      if block.az_page_az_project_blocks.size == 0
        @remove_result[block.owner] = [block.name + " (" + block.id.to_s + ")" ]
        #puts block.az_page_az_project_blocks.size
        #puts block.name + " " + block.id.to_s + " " + block.owner.name
        #block.destroy
      end
    end

    respond_to do |format|
      format.html { render :template => 'az_services/remove_seeds_result'}
    end

  end

  private
  def update_entity_from_seed(entity_class)

    if params[:id] == '0'
      entity = nil
    else
      entity = entity_class.find(params[:id])
    end

    companies = AzCompany.all
    @update_result = {}
    companies.each do |c|
      if c.ceo.login != 'seeder' # Пропускаем и ничего не обновляем у хозяина рассады
        if entity == nil
          @update_result[c] = entity_class.update_from_seed(c)
        else
          @update_result[c] = entity.sow(c)
        end
      end
    end

    respond_to do |format|
      format.html { render :template => '/az_services/result_update_seeds'}
    end

  end

end
