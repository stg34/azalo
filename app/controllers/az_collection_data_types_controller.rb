class AzCollectionDataTypesController < ApplicationController

  filter_access_to :new, :create, :index
  filter_access_to :all, :attribute_check => true

  layout "main"

  def index
    @az_collection_data_types = AzCollectionDataType.all

    @title = 'Коллекции'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @az_collection_data_types }
    end
  end

  def show
    @az_collection_data_type = AzCollectionDataType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @az_collection_data_type }
    end
  end

#  def new1
#
#    if params[:owner_id] && params[:az_base_data_type_id]
#      return new_for_type
#    end
#
#    owner = AzCompany.find(params[:owner_id])
#    @az_collection_data_type = AzCollectionDataType.new
#    @base_data_types = AzPageType.find_all_page_types(owner)
#    @collection_templates = AzCollectionTemplate.find(:all)
#    @az_collection_data_type.owner = owner
#    respond_to do |format|
#      format.html # new.html.erb
#    end
#  end

  def new
    
    data_type = AzBaseDataType.find(params[:az_base_data_type_id])
    collection = AzCollectionDataType.new
    collection_templates = AzCollectionTemplate.find(:all)
    collection.owner = data_type.owner
    collection.az_base_data_type = data_type
    collection.name = 'Список ' + data_type.name.downcase
    collection.az_base_project = data_type.az_base_project

    respond_to do |format|
      format.html { render :partial => '/az_collection_data_types/new_edit_dialog_container',
            :locals => {:collection => collection, :collection_templates => collection_templates} }
    end
  end

  def edit
    collection = AzCollectionDataType.find(params[:id])
    collection_templates = AzCollectionTemplate.find(:all)
    respond_to do |format|
      format.html { render :partial => '/az_collection_data_types/new_edit_dialog_container',
            :locals => {:collection => collection, :collection_templates => collection_templates} }
    end
  end

  def create
    data_type = AzBaseDataType.find(params[:az_collection_data_type][:az_base_data_type_id])
    collection = AzCollectionDataType.new(params[:az_collection_data_type])
    collection.az_base_project = data_type.az_base_project

    respond_to do |format|
      if collection.save
        format.html { render :text => "Успешно.<script type='text/javascript'>update_datatype_list();Windows.closeAll();</script>" }
      else
        collection_templates = AzCollectionTemplate.find(:all)
        format.html { render :partial => '/az_collection_data_types/new_edit_dialog',
            :locals => {:collection => collection, :collection_templates => collection_templates} }
      end
    end
  end

  def update
    collection = AzCollectionDataType.find(params[:id])
    collection.name = params[:az_collection_data_type][:name]
    collection.description = params[:az_collection_data_type][:description]
    respond_to do |format|
      if collection.save
        format.html { render :text => "Успешно.<script type='text/javascript'>update_datatype_list();Windows.closeAll();</script>" }
      else
        collection_templates = AzCollectionTemplate.find(:all)
        format.html { render :partial => '/az_collection_data_types/new_edit_dialog',
            :locals => {:collection => collection, :collection_templates => collection_templates} }
      end
    end
  end

  def destroy
    @az_collection_data_type = AzCollectionDataType.find(params[:id])
    @az_collection_data_type.destroy

    respond_to do |format|
      format.html { render :text => "Успешно.<script type='text/javascript'>update_datatype_list();Windows.closeAll();</script>" }
    end
  end

  def copy
    @az_collection_data_type = AzCollectionDataType.find(params[:id])
    @az_collection_data_type.make_copy
    
    respond_to do |format|
      format.html { redirect_to(az_collection_data_types_url) }
      format.xml  { head :ok }
    end
    
  end

  private

  def new_for_type
    owner = AzCompany.find(params[:owner_id])
    data_type = AzBaseDataType.find(params[:az_base_data_type_id])
    
    @az_collection_data_type = AzCollectionDataType.new
    @collection_templates = AzCollectionTemplate.find(:all)
    @az_collection_data_type.owner = owner
    @az_collection_data_type.az_base_data_type = data_type
    @az_collection_data_type.name = 'Список ' + data_type.name.downcase
    @az_collection_data_type.az_base_project = data_type.az_base_project

    respond_to do |format|
      format.html { render :template => 'az_collection_data_types/new_for_type' }
    end
  end

end
