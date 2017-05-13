class AzSimpleDataType < AzBaseDataType

  # TODO валидировать:
  # az_base_data_type_id - всегда NULL
  # az_collection_template_id - всегда NULL
  # owner_id - ???
  # seed - простой тип данных не может быть seed
  # az_base_project_id - простой тип данных не может принадлежать проекту

  def make_copy_data_type(owner, project)
    return self
  end

  def find_copied_or_make_copy(owner, project)
    #puts "AzSimpleDataType:find_copied_or_make_copy"
    return self
  end

  def self.get_my_types
    return find(:all, :conditions => {:owner_id => 2}) #TODO вынести простые типы данных в отдельную таблицу. Указание owner_id нужно для ускорения поиска по огромной таблице переменных
  end

  def self.get_undefined_data_type
    return find(:first, :conditions => {:owner_id => 2, :name => 'Неопределенный'}) #TODO вынести простые типы данных в отдельную таблицу. Указание owner_id нужно для ускорения поиска по огромной таблице переменных
  end

  def get_project
    return nil
  end

end
