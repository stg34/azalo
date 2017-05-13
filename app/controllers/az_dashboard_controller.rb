class AzDashboardController < ApplicationController

  layout "main"

  def index_old

    #session[:hide_warnings] = nil

    if current_user != nil && current_user.never_visited
      current_user.never_visited = false
      current_user.save!
      current_user.az_companies.each do |c|

        puts c.inspect
        c.create_default_content
      end
    end

    @news = AzNews.get_latest_news

  end

  def index
    session[:foo_bar] = nil

    if current_user != nil && current_user.never_visited
      current_user.never_visited = false
      current_user.save!
      current_user.az_companies.each do |c|

        #TODO Как-то криво это
        projects = AzProject.get_by_company(c)
        projects.each do |project|
          if project.az_participants.size == 0
            project.set_default_participants(project.owner.ceo)
          end
        end

        puts c.inspect
        c.create_default_content
      end
    end

    @latest_items = AzStoreItem.latests
    @news = AzNews.get_latest_news
    @last = @news.sort{|a, b| b.created_at <=> a.created_at}[0]

    @active_projects = AzActivity.get_active_projects
    @latest_projects = AzProject.get_latest_projects
    @popular_projects = AzProject.get_popular_projects
   
    @new_users_this_week = AzUser.count_by_sql("SELECT count(*) FROM `az_users` WHERE created_at > date_add(now(), interval -7 day) and email not like '%@foo.com'")
    @new_projects_this_week = AzProject.count_new_this_week

    @public_projects = AzProject.find_last_public_projects
    @public_active_projects = AzProject.find_last_public_active_projects
    @public_noteworthy_projects = AzProject.find_last_public_noteworthy_projects

    respond_to do |format|
      format.html { render :layout => 'index'}
    end
  end

  def explore
    @active_projects = AzProject.find_last_public_active_projects
    @latest_projects = AzProject.get_latest_public_projects(5)
    #@popular_projects = AzProject.get_popular_projects(10)
    @public_noteworthy_projects = AzProject.find_last_public_noteworthy_projects

#    @active_projects.each do |active_project|
#      p active_project
#    end

    respond_to do |format|
      format.html { render :template => '/az_dashboard/explore_projects', :layout => 'index'}
    end
  end

  def explore_all
    @projects = AzProject.get_piblic_projects(params[:page])
    respond_to do |format|
      format.html { render :template => '/az_dashboard/explore_all', :layout => 'index', :locals => {:title => 'Все проекты'}}
    end
  end

  def explore_active
    @projects = AzProject.find_last_public_active_projects(:page => params[:page])
    respond_to do |format|
      format.html { render :template => '/az_dashboard/explore_all', :layout => 'index', :locals => {:title => 'Все активные проекты'}}
    end
  end

  def explore_noteworthy
    #@projects = AzProject.get_piblic_projects(params[:page])
    @projects = AzProject.find_public_noteworthy_projects(params[:page])
    prj = AzProject.find(9589, :include => :stat)
    respond_to do |format|
      format.html { render :template => '/az_dashboard/explore_all', :layout => 'index', :locals => {:title => 'Все хорошие проекты'}}
    end
  end

  def new_index
    session[:foo_bar] = nil

    if current_user != nil && current_user.never_visited
      current_user.never_visited = false
      current_user.save!
      current_user.az_companies.each do |c|

        #TODO Как-то криво это
        projects = AzProject.get_by_company(c)
        projects.each do |project|
          if project.az_participants.size == 0
            project.set_default_participants(project.owner.ceo)
          end
        end

        puts c.inspect
        c.create_default_content
      end
    end

    @latest_items = AzStoreItem.latests
    @news = AzNews.get_latest_news
    @last = @news.sort{|a, b| b.created_at <=> a.created_at}[0]

    @active_projects = AzActivity.get_active_projects
    @latest_projects = AzProject.get_latest_projects
    @popular_projects = AzProject.get_popular_projects

    @new_projects_this_week = AzProject.count_by_sql("SELECT count(*) FROM `az_base_projects` WHERE created_at > date_add(now(), interval -7 day) and type='AzProject' and (copy_of is NULL or copy_of <>355)")
    @new_users_this_week = AzUser.count_by_sql("SELECT count(*) FROM `az_users` WHERE created_at > date_add(now(), interval -7 day) and email not like '%@foo.com'")

    respond_to do |format|
      format.html { render :layout => 'index'}
    end
  end

  def store
    respond_to do |format|
      format.html { render :layout => 'store'}
    end
  end


  def video
    session[:foo_bar] = nil

    if current_user != nil && current_user.never_visited
      current_user.never_visited = false
      current_user.save!
      current_user.az_companies.each do |c|
        puts c.inspect
        c.create_default_content
      end
    end

    @news = AzNews.get_latest_news
    @last = @news.sort{|a, b| b.created_at <=> a.created_at}[0]

    respond_to do |format|
      format.html { render :layout => 'index', :template => "/az_dashboard/video.html", :locals => {:video_id => params[:id]} }
    end
  end

  def tariff_test
    tariffs = AzTariff.get_user_available_tariffs
    respond_to do |format|
      format.html { render :layout => 'index', :template => "/az_dashboard/tariff_test.html", :locals => {:tariffs => tariffs} }
    end
  end

  def tariffs
    tariffs = AzTariff.get_future_tariffs
    respond_to do |format|
      format.html { render :layout => 'index', :template => "/az_dashboard/tariffs.html", :locals => {:tariffs => tariffs} }
    end
  end

end
