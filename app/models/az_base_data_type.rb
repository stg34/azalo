class AzBaseDataType < OwnedActiveRecord

  StructTypeId = 0
  CollectionTypeId = 1
  DataTypes = {'AzStructDataType' => {:name => 'Структура', :id => StructTypeId},
               'AzCollectionDataType' => {:name => 'Коллекция', :id => CollectionTypeId},
  }

  DataTypeById = {StructTypeId =>     {:name => 'Структура', :class_name => 'AzStructDataType'},
                  CollectionTypeId => {:name => 'Коллекция', :class_name => 'AzCollectionDataType'},
  }

  #has_many :az_collection_data_types, :dependent => :destroy
  has_many :az_typed_pages, :dependent => :destroy
  has_many :az_variables, :dependent => :destroy
  has_many :variables_of_this_type, :foreign_key => 'az_base_data_type_id', :class_name=>'AzVariable', :dependent => :destroy
    
  #TODO валидировать, az_base_project.owner_id == owner_id

  validates_presence_of     :name

  before_create :set_initial_position

  has_many :az_operation_times
  has_many :az_collection_data_types, :foreign_key => 'az_base_data_type_id', :source => 'az_collection_data_type', :dependent => :destroy # Обратная сторона из AzCollectionDataType  belongs_to :az_base_data_type

  #has_many :az_pages, :through => :az_typed_pages, :source => 'az_page'
  #has_many :typed_pages, :through => :az_typed_pages, :source => 'az_page', :dependent => :destroy
  has_many :az_typed_pages, :foreign_key => 'az_base_data_type_id'
  has_many :typed_pages, :through => :az_typed_pages, :source => 'az_page'

  belongs_to :az_base_project

  def to_az_hash
    attributes
  end

  def make_copy_data_type(owner, project)
    return self
  end

#  def find_parent_project_ids
#    ids = []
#    typed_pages.each do |pg|
#      ids = pg.get_project_over_block.id
#      ids = pg.get_project.id
#    end
#
#    az_collection_data_types.each do |cdt|
#      ids.concat(cdt.find_parent_project_ids)
#    end
#
#    puts ids.uniq
#
#    return ids.uniq
#  end

  def data_type_type
    return DataTypes[self.class.to_s]
  end

  def find_parent_project_ids
    if az_base_project.class == AzProjectBlock
      return [az_base_project_id]
    end
    ids = [az_base_project_id]

    ids.concat(az_base_project.get_project_block_list.collect{|pb| pb.id }) if az_base_project != nil

    #puts "ids = " + ids.inspect

    return ids
  end

  def find_copied_data_type(project)
    data_types1 = AzStructDataType.find(:all, :conditions => { :copy_of => id, :owner_id => project.owner_id})
    data_types2 = AzCollectionDataType.find(:all, :conditions => { :copy_of => id, :owner_id => project.owner_id})
    data_types = data_types1.concat(data_types2)
    ds_short = data_types.collect{|dt| [dt.id, dt.name]}
    #puts ds_short.inspect
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    data_types.each do |dt|
      #puts dt.name + " id=" + dt.id.to_s + " copy_of=" + dt.copy_of.to_s
      
      # Ищем тип среди типов находящихся внутри коллекций
      # TODO Это нужно оптимизировать, т.к. список az_collection_data_types может оказаться огромным
      if dt.find_parent_project_ids.include?(project.id)
        puts 'FOUND COPIED!!!'
        return dt
      end
    end
    puts 'COPY NOT FOUND!!!'
    return nil
  end

  def find_copied_or_make_copy(owner, project)
    
    if project != nil
      copied = find_copied_data_type(project)
      if copied != nil
        return copied
      end
    end
    
    return make_copy_data_type(owner, project)
  end

  def get_operation_time(operation)
    az_operation_times.each do |opt|
      if opt.az_operation.id == operation.id
        return opt.operation_time
      end
    end
    return 0.5 # TODO установить -10, чтоб в глаза брасалось
  end

  def get_by_project(project)
    AzBaseDataType.find_by_az_base_project_id(project.id)
  end

  def self.get_unussigned(owner)
    return AzBaseDataType.find_all_by_owner_id(owner.id, :conditions => 'az_base_project_id is null')
  end

  def set_initial_position
    d = AzDefinition.find(:last, :order => :id)
    if d == nil
      self.position = 1
    else
      self.position = d.id + 1
    end
  end



end
