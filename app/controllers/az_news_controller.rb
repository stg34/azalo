class AzNewsController < ApplicationController
  # GET /az_news
  # GET /az_news.xml

  layout "main"

  filter_access_to :all

  def index
    @az_news = AzNews.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_news }
    end
  end

  # GET /az_news/1
  # GET /az_news/1.xml
  def show
    @az_news = AzNews.find(params[:id])

    respond_to do |format|
      #format.html # show.html.erb
      format.html { render :layout => 'index' }
      format.xml  { render :xml => @az_news }
    end
  end

  # GET /az_news/new
  # GET /az_news/new.xml
  def new
    @az_news = AzNews.new
    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @az_news }
    end
  end

  def archive
    @news = AzNews.find(:all, :conditions => "visible = 1")
    begin
      y = Integer(params[:year])
      m = Integer(params[:month])
    rescue
      y_m = AzNews.get_latest_news_year_month
      y = y_m[0]
      m = y_m[1]
    end

    if m > 12 || m < 1 || y < 2011
      y_m = AzNews.get_latest_news_year_month
      y = y_m[0]
      m = y_m[1]
    end
    @last_y_m = AzNews.find(:all, :conditions => "visible = 1 and created_at >= DATE('#{y}-#{m}-01') and created_at < DATE_ADD('#{y}-#{m}-01', INTERVAL 1 MONTH)" )
    @news_by_month = {}
    @news.each do |n|
      @news_by_month[n.created_at.year] ||= []
      @news_by_month[n.created_at.year] << n.created_at.month
      @news_by_month[n.created_at.year].uniq!
    end

    respond_to do |format|
      format.html { render :layout => 'index'}
    end
  end

  # GET /az_news/1/edit
  def edit
    @az_news = AzNews.find(params[:id])
  end

  # POST /az_news
  # POST /az_news.xml
  def create
    @az_news = AzNews.new(params[:az_news])
    @az_news.az_user = current_user
    respond_to do |format|
      if @az_news.save
        flash[:notice] = 'Новость успешно создана.'
        format.html { redirect_to(@az_news) }
        format.xml  { render :xml => @az_news, :status => :created, :location => @az_news }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @az_news.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /az_news/1
  # PUT /az_news/1.xml
  def update
    @az_news = AzNews.find(params[:id])

    respond_to do |format|
      if @az_news.update_attributes(params[:az_news])
        flash[:notice] = 'Новость успешно обновлена.'
        format.html { redirect_to(@az_news) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @az_news.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /az_news/1
  # DELETE /az_news/1.xml
  def destroy
    @az_news = AzNews.find(params[:id])
    @az_news.destroy

    respond_to do |format|
      format.html { redirect_to(az_news_url) }
      format.xml  { head :ok }
    end
  end
end
