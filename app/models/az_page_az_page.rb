class AzPageAzPage < ActiveRecord::Base

  attr_accessible :az_parent_page, :az_page, :position

  belongs_to :az_parent_page, :class_name => 'AzPage', :foreign_key => :parent_page_id
  #belongs_to :page, :class_name => 'AzPage', :foreign_key => :page_id
  belongs_to :az_page, :class_name => 'AzPage', :foreign_key => :page_id

  validates_uniqueness_of :page_id, :scope=>:parent_page_id

#  def validate_uniq_page_parent_page
#    # pair page and parent page should be uniq TODO add index to DB
#    link = AzPageAzPage.find(:first, :conditions => {:page_id => page_id, :parent_page_id=> parent_page_id})
#    if link
#      errors.add(:base, "Page can be connected to some parent only once")
#    end
#  end

  before_create  :set_initial_position

  after_destroy :destroy_page

  def set_initial_position
    #TODO
    last = AzPageAzPage.find(:last)
    if last == nil
      self.position = 1
    else
      self.position = last.id + 1
    end
    
  end

  def destroy_page
    if az_page && az_page.parents.size == 0
      az_page.destroy
    end
  end

  def self.from_az_hash(attributes, page_ids_original_copy)
    page_link = AzPageAzPage.new
    page_link.parent_page_id = page_ids_original_copy[attributes['parent_page_id']]
    page_link.page_id = page_ids_original_copy[attributes['page_id']]
    return page_link
  end

end
