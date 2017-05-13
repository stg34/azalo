class AzActivity < ActiveRecord::Base
  has_many :az_activity_fields, :dependent => :destroy
  belongs_to :az_user, :foreign_key => :user_id
  belongs_to :az_project, :foreign_key => :project_id
  belongs_to :az_company, :foreign_key => :owner_id

  def self.get_active_projects(hours = 7*24)
    #activities = find_by_sql("SELECT *, count(*) as cnt  FROM az_activities WHERE (created_at >DATE_ADD(NOW(), INTERVAL -#{hours} HOUR)) GROUP BY project_id order by cnt desc limit 5")

    activities = find_by_sql("SELECT az_activities.*, count(*) as cnt, az_base_projects.name
                              FROM az_activities
                              LEFT JOIN az_base_projects ON az_activities.project_id = az_base_projects.id
                              WHERE (az_base_projects.type = 'AzProject' and az_activities.created_at >DATE_ADD(NOW(), INTERVAL -#{hours} HOUR)) GROUP BY project_id order by cnt desc limit 5")

    projects = activities.collect{|a| a.az_project}
    return projects
  end

end
