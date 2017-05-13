class AzStoreItemScetch < ActiveRecord::Base

  belongs_to :az_store_item

  has_attached_file :scetch, :styles => { :big => "700x700>", :medium => '400x600>', :small => "194x400>", :tiny => "100x200>"}

end
