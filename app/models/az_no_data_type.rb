class AzNoDataType < AzBaseDataType
  self.abstract_class = true

  def initialize(*args)
    super
    self[:name] = 'no data type'
    self[:id] = -1
  end

end

