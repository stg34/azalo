namespace :azalo  do
  desc 'remove_old_project_stat'
  task :remove_old_project_stat => :environment do
    projects = AzBaseProject.all
    projects.each do |prj|
      last_stat_id = prj.stats(:order => 'created_at').last.try(:id)
      if last_stat_id
        to_destroy = AzBaseProjectStat.find(:all, :conditions => "az_base_project_id = #{prj.id} and id <> #{last_stat_id}")
        if to_destroy.count > 0
          puts "#{prj.id} -- #{to_destroy.count}"
          ids = to_destroy.map(&:id)
          AzBaseProjectStat.delete(ids)
        end
      end
    end
  end
end
