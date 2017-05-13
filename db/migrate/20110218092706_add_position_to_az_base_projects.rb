class AddPositionToAzBaseProjects < ActiveRecord::Migration
  def self.up
    Authorization.current_user = AzUser.find_by_login('admin')

    add_column :az_base_projects, :position, :integer

    project_classes = [AzProject, AzProjectBlock]
    companies = AzCompany.all
    companies.each do |company|
      project_classes.each do |project_class|
        projects = project_class.get_by_company(company)
        n = 0
        projects.each do |project|
          project.position = n
          project.save
          n += 1
        end
      end
    end
  end

  def self.down
    remove_column  :az_base_projects, :position
  end
end
