class AzCommonsCommon < AzCommon

  belongs_to :matrix, :class_name=>'AzCommonsCommon', :foreign_key=>'copy_of'

  def self.get_label
    return "Общие положения"
  end

  def self.get_default
    return find(:first)
  end
  
end
