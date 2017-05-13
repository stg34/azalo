class AzCommonsRequirementsHosting < AzCommon
 
  belongs_to :matrix, :class_name=>'AzCommonsRequirementsHosting', :foreign_key=>'copy_of'

  def self.get_label
    return "Требования к хостингу"
  end

  def self.get_default
    return find(:first)
  end

end
