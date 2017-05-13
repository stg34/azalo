class AzCommonsFunctionality < AzCommon

  belongs_to :matrix, :class_name=>'AzCommonsFunctionality', :foreign_key=>'copy_of'

  def self.get_label
    return "Функциональные характеристики"
  end

  def self.get_default
    return [] #find(:first)
  end

end
