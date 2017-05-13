class AzEnumDataType < AzBaseDataType
  def make_copy_data_type(owner, project)

  end

  def self.get_seeds
    return AzEnumDataType.find_all_by_seed(true)
  end

end
