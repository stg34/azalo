namespace :azalo  do
  desc "updates stats of projects"

  task :update_projects_stat => :environment do

    Authorization.current_user = AzUser.find_by_login('admin')

    last_update = AzProjectStatUpdate.find(:last, :order => :id)

    if last_update == nil
      last_update = AzProjectStatUpdate.new()
      last_update.created_at = Time.local(2000, "jan", 1)
    end

    new_last_update = AzProjectStatUpdate.new()
    new_last_update.save

    activities = AzActivity.find_by_sql("SELECT distinct project_id FROM az_activities WHERE  created_at > '#{last_update.created_at.strftime("%Y.%m.%d") }'")
    project_to_update_ids = activities.collect{|a| a.project_id}.reject{|id| id == nil}
    #project_to_update_ids = [8806, 10248]
    p project_to_update_ids
    puts "SELECT distinct project_id FROM az_activities WHERE  created_at > '#{last_update.created_at.strftime("%Y.%m.%d") }'"
    project_to_update_ids.each do |project_to_update_id|
      project_to_update = AzBaseProject.find(:first, :conditions => {:id => project_to_update_id})
      if project_to_update
        puts "Updating stat for project #{project_to_update.id} - #{project_to_update.name}"
        project_to_update.update_stats
      end
    end
  end
end
