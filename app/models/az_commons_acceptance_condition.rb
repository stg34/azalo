class AzCommonsAcceptanceCondition < AzCommon

  belongs_to :matrix, :class_name=>'AzCommonsAcceptanceCondition', :foreign_key=>'copy_of'

  def self.get_label
    return "Условия сдачи и приемки"
  end

  def self.get_default
    return find(:first)
  end

end
