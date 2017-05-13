class AzCommonsPurposeFunctional < AzCommon

  belongs_to :matrix, :class_name=>'AzCommonsPurposeFunctional', :foreign_key=>'copy_of'

  def self.get_label
    return "Функциональное назначение"
  end

  def self.get_default
    return find(:first)
  end

end
