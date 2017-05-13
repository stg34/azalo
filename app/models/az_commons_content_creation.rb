class AzCommonsContentCreation < AzCommon

  belongs_to :matrix, :class_name=>'AzCommonsContentCreation', :foreign_key=>'copy_of'

  def self.get_label
    return "Наполнение сайта"
  end

  def self.get_default
    return find(:first)
  end

end
