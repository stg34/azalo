require 'rubygems'
require 'paperclip'

class AzDesign < OwnedActiveRecord

  attr_accessible :description, :az_page_id, :created_at, :updated_at, :owner_id, :copy_of

  belongs_to  :az_page
  
  has_many    :az_images, :dependent => :destroy
  has_one     :az_design_source, :dependent => :destroy
  #accepts_nested_attributes_for :az_images, :reject_if => proc { |attributes| attributes['image'].blank?}, :allow_destroy => true

  validates_presence_of :description
  validates_presence_of :az_page

  #has_attached_file :design_source
  #has_attached_file :design_tmp_source
  
  attr_accessor :design_rnd

  before_save :check_parent_page

  validate :design_valid

  def design_valid
    validate_parent_not_root
    validate_owner_id
  end

  def validate_owner_id
    if az_page == nil
      errors.add(:base, "No parent page! Design '#{id}'")
      return
    end
    if az_page.owner_id != owner_id
      errors.add(:base, "Incorrect owner_id value. Page has '#{az_page.owner_id}', Design has '#{owner_id}'")
    end
  end

  def validate_parent_not_root
    if az_page && az_page.root
      errors.add(:base, 'Design cannot belongs to root page')
    end
  end

  def check_parent_page
    if self.id
      old = AzDesign.find(self.id)
      if old.az_page_id != self.az_page_id
        raise "Exception!!!"
      end
    end
    puts "--------- =-= DESIGN =-= id: #{self.id}  page_id: #{self.az_page_id}  -------------------"
  end

  def self.get_model_name
    return "Дизайн"
  end

  def get_label_for_activity
    return "#{self.description} (#{az_page.get_label_for_activity})"
  end


  def get_project
    if az_page == nil
      return nil
    end

    return az_page.get_project
  end

  def get_project_over_block
    if az_page == nil
      return nil
    end

    return az_page.get_project_over_block
  end

  def get_head_az_image
    if az_images.size > 0
      return az_images[az_images.size - 1]
    end

    return no_az_image
  end

  def get_all_images
    if az_images.size > 1
      return az_images[0..az_images.size - 1]
    end
    return [no_az_image]
  end

  def get_tail_az_images
    if az_images.size > 1
      return az_images[0..az_images.size - 2]
    end
    return []
  end

  def has_az_images
    return az_images.size > 0
  end

  def no_az_image
    return AzImage.new
  end

  def make_copy_design(project, page)
    puts "DESIGN MAKE_COPY new_owner_id = #{page.owner.id}"
    dup = self.az_clone
    dup.copy_of = id
    dup.az_page = page
    dup.owner = page.owner
    dup.save!

    # TODO тут может быть исключение, если файла не существует на диске. Обработать этот случай
    #dup.design_source = design_source

    if az_design_source != nil
      #dup.az_design_source = 
      az_design_source.make_copy_design_source(dup)
    end

    az_images.each do |img|
      img.make_copy_image(dup)
      #new_img = img.make_copy_image(dup)
      #if new_img != nil
      #  dup.az_images << new_img
      #end
    end
    
    
    puts "2 DESIGN MAKE_COPY new_owner_id = #{page.owner.id}"
    return dup.reload
  end

  def can_be_uploaded
    return true #!owner.disk_quota_exceeded
  end

  def self.from_az_hash(attributes, page_ids_original_copy, company)
    design = AzDesign.new(attributes)
    design.copy_of = attributes['id']
    design.owner = company
    design.az_page_id = page_ids_original_copy[attributes['az_page_id']]
    return design
  end

end

