class AzCImage < ActiveRecord::Base

  belongs_to :item, :polymorphic => true

  has_attached_file :c_image, :styles => { :big => "600x1200>", :medium => '400x800>', :small => "200x400>", :tiny => "100x200>"}

  validates_attachment_size           :c_image, :in => 1..2.megabytes
  validates_attachment_content_type   :c_image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates_attachment_presence       :c_image

end
