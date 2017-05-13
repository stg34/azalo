class AzTrText < OwnedActiveRecord

  belongs_to :matrix,   :class_name => 'AzTrText', :foreign_key => 'copy_of'

  belongs_to :az_operation

  validates_presence_of :name
  validates_presence_of :text

  def self.get_by_company(company)
    return find_all_by_owner_id(company.id, :order => "data_type, az_operation_id")
  end

  def get_description(node, data_type)
    page = node.main_page

    puts node.get_children.size

    description = text

    if data_type && (data_type.class != AzCollectionDataType && data_type.class != AzStructDataType)
      return description
    end

    uploaded_designs = page.get_designs.select{|d| d.az_design_source != nil}
    designs_with_images = page.get_designs.select{|d| d.has_az_images }
    az_url = AZ_URL.to_s
    az_url = az_url[0..-2] if az_url[-1, 1] == '/'

    substitusions = {'%child_pages%' => node.get_children.collect{|c| "* #{c.main_page.name}\n"}.join,
                     '%page_name%' => page.name,
                     '%page_title%' => page.title,
                     '%design_list%' => uploaded_designs.collect{|d| "* \"#{d.description}\":#{az_url}#{d.az_design_source.source.url(:original, false)}\n"}.join,
                     '%image_list%' => designs_with_images.collect{|d| "* \"#{d.description}\":#{az_url}#{d.get_head_az_image.image.url(:original, false)}\n"}.join,
                     '%project_name%' => page.get_project_over_block.name}

    if data_type != nil
      substitusions.merge!({'%variable_list%' => variables_list(data_type)})
      if data_type.class == AzCollectionDataType
        substitusions.merge!({'%data_type_name%' => data_type.az_base_data_type.name.downcase,
                               '%collection_name%' => data_type.name.downcase,})
      else
        substitusions.merge!({'%data_type_name%' => data_type.name.downcase})
      end
    end

    substitusions.each_pair do |s, v|
      description.gsub!(s, v.to_s)
    end
    
    return description
  end

  def variables_list(data_type, level = 1, processed_ids = {})

    if data_type.class == AzStructDataType
      struct = data_type
    elsif data_type.class == AzCollectionDataType
      struct = data_type.az_base_data_type
    end

    processed_ids[struct.id] = level

    str = "\n"
    struct.az_variables.each do |variable|
      str += ('*'*level + " " + h(variable.name) + "\n")

      if variable.az_base_data_type.instance_of?(AzStructDataType) && processed_ids[variable.az_base_data_type.id] = nil
        str += variables_list(variable.az_base_data_type level + 1)
      end

      if variable.az_base_data_type.instance_of?(AzCollectionDataType) && processed_ids[variable.az_base_data_type.id] = nil
        str += variables_list(variable.az_base_data_type.az_base_data_type, level + 1)
      end
    end

    return str + "\n"
  end
  
  def self.create_show_content
    # Контент, который используется при предпросмотре задачи в редакторе шаблонов задач
    project = AzProject.new(:name => 'Проект для проверки задач')
    page = AzPage.new(:name => 'Страница для проверки задач',
                      :title => 'Заголовок страницы для проверки задач',
                      :description => 'Эта страница предназначена для проверки того, как будет выглядеть текст задачи.',
                      :az_base_project => project)


    root = AzPage.new(:name => 'root',
                        :title => 'root',
                        :description => 'root',
                        :az_base_project => project)

    page_1 = AzPage.new(:name => 'Дочерняя страница 1',
                        :title => 'Заголовок дочерней страницы 1',
                        :description => 'Эта страница предназначена для проверки того, как будет выглядеть текст задачи.',
                        :az_base_project => project)

    page_2 = AzPage.new(:name => 'Дочерняя страница 2',
                        :title => 'Заголовок дочерней страницы 2',
                        :description => 'Эта страница предназначена для проверки того, как будет выглядеть текст задачи.',
                        :az_base_project => project)

    page_3 = AzPage.new(:name => 'Дочерняя страница 3',
                        :title => 'Заголовок дочерней страницы 3',
                        :description => 'Эта страница предназначена для проверки того, как будет выглядеть текст задачи.',
                        :az_base_project => project)

    root.children << page
    root.child_links << AzPageAzPage.new(:az_parent_page => root, :az_page => page, :position => 0)

    page.children << page_1
    page.child_links << AzPageAzPage.new(:az_parent_page => page, :az_page => page_1, :position => 1)

    page.children << page_2
    page.child_links << AzPageAzPage.new(:az_parent_page => page, :az_page => page_2, :position => 2)

    page.children << page_3
    page.child_links << AzPageAzPage.new(:az_parent_page => page, :az_page => page_3, :position => 3)

    design1 = AzDesign.new(:description => 'Основной дизайн')
    design2 = AzDesign.new(:description => 'Еще один дизайн страницы')
    design_source1 = AzDesignSource.new(:az_design => design1, :id => -1, :source_file_name => 'design1.psd')
    design_source2 = AzDesignSource.new(:az_design => design2, :id => -2, :source_file_name => 'design2.psd')
    design1.az_design_source = design_source1
    design2.az_design_source = design_source2

    image1 = AzImage.new(:az_design => design1, :image_file_name => 'design1.jpg')
    image2 = AzImage.new(:az_design => design2, :image_file_name => 'design2.jpg')

    design1.az_images << image1
    design2.az_images << image2

    page.az_designs << design1
    page.az_designs << design2
    project.az_pages << root

    operation = AzOperation.find(1)
    string_dt = AzSimpleDataType.find(:first, :conditions => {:name => 'Строка'})

    data_type = AzStructDataType.new(:name => 'Новость')
    var1 = AzVariable.new(:name => 'Название', :az_base_data_type => string_dt)
    var2 = AzVariable.new(:name => 'Анонс', :az_base_data_type => string_dt)
    var3 = AzVariable.new(:name => 'Текст', :az_base_data_type => string_dt)
    data_type.az_variables << var1
    data_type.az_variables << var2
    data_type.az_variables << var3

    operation = AzOperation.find(1)
    
    template = AzCollectionTemplate.new

    collection = AzCollectionDataType.new(:az_base_data_type => data_type, :az_collection_template => template, :name => "Список новостей")

    link = root.child_links[0]
    puts root.child_links.inspect
    tree = PrTree.build_sub_tree(nil, link, 2)
    puts tree.root.main_page.name

    return tree.root, data_type, operation, collection
  end

  def self.get_seeds
    return AzTrText.find_all_by_seed(true)
  end

  def make_copy(owner)
    dup = self.az_clone
    dup.copy_of = id
    dup.owner = owner
    dup.seed = false
    dup.save!
    return dup
  end

end
