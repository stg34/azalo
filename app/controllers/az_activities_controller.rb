class AzActivitiesController < ApplicationController

  filter_access_to :all

  layout 'main'

  def index
    @az_activities = AzActivity.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_activities }
    end
  end

  def active_companies
    @az_activities = AzActivity.find_by_sql("SELECT *, count(*) as cnt  FROM az_activities WHERE (created_at >DATE_ADD(NOW(), INTERVAL -7 DAY)) GROUP BY owner_id order by cnt desc limit 10")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_activities }
    end
  end

  def active_projects
    @az_activities_last_week = AzActivity.find_by_sql("SELECT *, count(*) as cnt  FROM az_activities WHERE (created_at >DATE_ADD(NOW(), INTERVAL -7 DAY)) GROUP BY project_id order by cnt desc limit 10")
    @az_activities_last_day = AzActivity.find_by_sql("SELECT *, count(*) as cnt  FROM az_activities WHERE (created_at >DATE_ADD(NOW(), INTERVAL -1 DAY)) GROUP BY project_id order by cnt desc limit 10")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_activities }
    end
    
  end
  
end