class AzStoreController < ApplicationController

  filter_access_to :all

  layout "main"

  # GET /az_stores/1
  # GET /az_stores/1.xml
  def store
    #@az_store = AzStore.find(params[:id])

    #component_items = AzStoreItem.find(:all, :conditions => {:visible => true, :item_type => 'AzProjectBlock'})
    #component_ids = component_items.collect{|ci| ci.item_id}
    #components = AzProjectBlock.find(component_ids)

    unless read_fragment(:action => 'store')
      items = AzStoreItem.store_items
      project_items = items.select{|i| i.item_type == 'AzProject'}
      component_items = items.select{|i| i.item_type == 'AzProjectBlock'}
    end

    @title = 'Магазин технических заданий'
    respond_to do |format|
      #format.html #{ render(:locals => {:components => components})}
      format.html {render(:template => 'az_store/store', :locals => {:project_items => project_items, :component_items => component_items})}
    end
  end

  def rss
    @items = AzStoreItem.store_items
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end

end
