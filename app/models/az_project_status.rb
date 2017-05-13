class AzProjectStatus < ActiveRecord::Base

  PS_disabled = 1
  PS_enabled = 0

  ProjectStatus_states = [['Активен', PS_enabled],
                          ['Не доступен', PS_disabled ]]
  

  def self.get_my_statuses
    return AzProjectStatus.find(:all)
  end

  def self.get_frozen_status
    AzProjectStatus.find(8) # TODO magic number 8...
  end

end
