class AzGuestLinksController < ApplicationController

  filter_access_to :new, :create, :index_project, :index
  filter_access_to :all, :attribute_check => true

  layout 'main'

  def index
    @az_guest_links = AzGuestLink.find(:all)

    respond_to do |format|
      format.html { render :template => 'az_guest_links/admin_index'}
      format.xml  { render :xml => @az_guest_links }
    end
  end

  def index_project
    AzGuestLink.remove_expired_links
    @project = AzProject.find(params[:id])
    @az_guest_links = AzGuestLink.get_project_guest_links(@project)

    respond_to do |format|
      format.html { render :template => 'az_guest_links/index'}
      format.xml  { render :xml => @az_guest_links }
    end
  end

  # GET /az_guest_links/1
  # GET /az_guest_links/1.xml
  def show
    @az_guest_link = AzGuestLink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_guest_link }
    end
  end

  def new
    az_guest_link = AzGuestLink.new
    az_guest_link.expired_in = 7
    az_base_project = AzProject.find(params[:id])
    az_guest_link.az_base_project_id = az_base_project.id

    respond_to do |format|
      format.html { render :partial => '/az_guest_links/new_edit_dialog_container', :locals => {:az_guest_link => az_guest_link} }
    end
  end

  # GET /az_guest_links/1/edit
  def edit
    az_guest_link = AzGuestLink.find(params[:id])
    e = AzGuestLink::Link_expirations.index{|le| Time.now.advance(:days => le[1])  > az_guest_link.expired_at}
    le = AzGuestLink::Link_expirations[e]
    puts le.inspect
    az_guest_link.expired_in = le[1]

    respond_to do |format|
      format.html { render :partial => '/az_guest_links/new_edit_dialog_container', :locals => {:az_guest_link => az_guest_link} }
    end
  end

  # POST /az_guest_links
  # POST /az_guest_links.xml
  def create
    @az_guest_link = AzGuestLink.new(params[:az_guest_link])
    project_id = Integer(params[:az_guest_link][:az_base_project_id])
    project = AzProject.find(project_id)
    @az_guest_link.owner_id = project.owner_id

    expired_in = Integer(@az_guest_link.expired_in)

    if expired_in > 0 && expired_in <= AzGuestLink::Link_expirations.last[1]
      @az_guest_link.expired_at = Time.now.advance(:days => expired_in)
    else
      @az_guest_link.expired_at = Time.now.advance(:days => 7)
    end
    
    respond_to do |format|
      if @az_guest_link.save
        flash[:notice] = 'Гостевая ссылка успешно создана.'
        format.html { render :text => 'Успешно. Подождите...<script type="text/javascript">reload_page();</script>' }
      else
        format.html { render :text => 'Подождите...<script type="text/javascript">reload_page();</script>' }
      end
    end
  end

  def update
    @az_guest_link = AzGuestLink.find(params[:id])
    expired_in = Integer(params[:az_guest_link][:expired_in])

    if expired_in > 0 && expired_in <= AzGuestLink::Link_expirations.last[1]
      @az_guest_link.expired_at = Time.now.advance(:days => expired_in)
    else
      @az_guest_link.expired_at = Time.now.advance(:days => 7)
    end

    respond_to do |format|
      if @az_guest_link.save
        flash[:notice] = 'Гостевая ссылка успешно изменена.'
        format.html { render :text => 'Успешно. Подождите...<script type="text/javascript">reload_page();</script>' }
      else
        format.html { render :text => 'Подождите...<script type="text/javascript">reload_page();</script>' }
      end
    end
  end

  def destroy
    @az_guest_link = AzGuestLink.find(params[:id])
    project_id = @az_guest_link.az_base_project_id
    @az_guest_link.destroy

    respond_to do |format|
      format.html { redirect_to(:action => 'index_project', :id => project_id) }
      format.xml  { head :ok }
    end
  end
end
