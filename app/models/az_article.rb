class AzArticle < ActiveRecord::Base
  has_many :az_c_images, :as => :item

  accepts_nested_attributes_for :az_c_images, :reject_if => proc { |attributes| attributes['c_image'].blank? }

end
