class AzParticipant < OwnedActiveRecord
  attr_accessible :az_project, :az_employee, :owner

  belongs_to :az_project
  belongs_to :az_employee
end
