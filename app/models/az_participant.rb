class AzParticipant < OwnedActiveRecord
  belongs_to :az_project
  belongs_to :az_employee
end
