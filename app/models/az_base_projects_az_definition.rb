class AzBaseProjectsAzDefinition < OwnedActiveRecord

  # TODO validete az_base_project.owner_id == az_definition.owner_id == self.owner_id

  belongs_to :az_base_project
  belongs_to :az_definition
end
