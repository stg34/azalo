require 'rubygems'
require 'paperclip'
require 'fileutils'

Az_image_image_width_tiny=50
Az_image_image_height_tiny=75

Az_image_image_width_small=100
Az_image_image_height_small=150

Az_image_image_width_medium=200
Az_image_image_height_medium=300

Az_image_image_width_big=400
Az_image_image_height_big=600

class AzImage < ActiveRecord::Base #OwnedActiveRecord TODO
  #has_attached_file :image

  #has_attached_file :image, :styles => { :big => "400x600>", :medium => "200x300>", :small => "100x150>", :tiny => {:geometry => "50x75"} }
  belongs_to :az_design

  # TODO use OwnedActiveRecord
  belongs_to :owner, :foreign_key => 'owner_id', :class_name => 'AzCompany'

  ########################################################################################################################################################
  # очень странный баг. скорее всего баг paperclip-а
  # если такой стиль :tiny => {:geometry => "#{Az_image_image_width_tiny}x#{Az_image_image_height_tiny}", :processors => [:cropper]} }
  # тоdef make_copy_image(design)
  #   ......
  #       dup.image = image
  # приводил к исключению.
  # вынесение кропера за пределы одного стиля привел к нормализации работы
  has_attached_file :image, :styles => { :big =>    "#{Az_image_image_width_big}x#{Az_image_image_height_big}>",
                                         :medium => "#{Az_image_image_width_medium}x#{Az_image_image_height_medium}>",
                                         :small =>  "#{Az_image_image_width_small}x#{Az_image_image_height_small}>",
                                         :tiny =>   "#{Az_image_image_width_tiny}x#{Az_image_image_height_tiny}>"
  },    :processors => [:borderer]


  #  has_attached_file :image, :styles => { :big =>    "#{Az_image_image_width_big}x#{Az_image_image_height_big}>",
  #                                         :medium => "#{Az_image_image_width_medium}x#{Az_image_image_height_medium}>",
  #                                         :small =>  "#{Az_image_image_width_small}x#{Az_image_image_height_small}>",
  #                                         :tiny => {:geometry => "#{Az_image_image_width_tiny}x#{Az_image_image_height_tiny}", :processors => [:cropper]} }
  ########################################################################################################################################################

  after_post_process :save_tiny_image_dimensions

  def before_destroy
    puts "#{self.class} #{self.id}"
  end

  def save_tiny_image_dimensions
    geo = Paperclip::Geometry.from_file(image.queued_for_write[:tiny])
    self.tiny_image_width = geo.width
    self.tiny_image_height = geo.height
  end

  validates_attachment_size           :image, :in => 1..3.megabytes
  validates_attachment_content_type   :image, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
  validates_attachment_presence       :image

  def validate
    validate_owner_id
  end

  def validate_owner_id
    if !new_record? && az_design.owner_id != owner_id
      errors.add_to_base("Incorrect owner_id value. Design has '#{az_design.owner_id}', Image has '#{owner_id}'")
    end
  end

  #validates_presence_of :az_design

  def before_create
    AzImage.remove_unassigned_images
  end

  def self.from_az_hash(attributes, owner, design_ids_original_copy, local_copy = true)
    image = AzImage.new
    image.copy_of = attributes['id']
    image.owner = owner
    image.az_design_id = design_ids_original_copy[attributes['az_design_id']]

    if local_copy
      original_image = AzImage.find(image.copy_of)
      if original_image == nil
        #raise "Image not found!" #TODO log this
        return nil
      end
      
      if !FileTest::exist?(original_image.image.path)
        return nil
      end
      
      image.image = original_image.image
    end
    return image
  end

  def make_copy_image(design)
    puts "IMAGE MAKE_COPY new_owner_id = #{design.owner.id}"
    dup = self.clone
    dup.copy_of = id
    dup.az_design = design
    dup.owner = design.owner
    dup.save!

    #puts "==================================================================="
    path_from_to = {}

    image.styles.each_key do |style|
      path_from_to[image.path(style)] = dup.image.path(style)
    end
    path_from_to[image.path] = dup.image.path
    
    #path_from_to[.sort{|a, b| a.to_s <=> b.to_s}.collect{|style| image.path(style) }] = dup.image.styles.each_key.sort{|a, b| a.to_s <=> b.to_s}.collect{|style| dup.image.path(style) }
    #path_to = dup.image.styles.each_key.sort{|a, b| a.to_s <=> b.to_s}.collect{|style| dup.image.path(style) }
    #path_from << image.path
    #path_to << dup.image.path

    #puts path_from_to.inspect
    #puts path_from.inspect
    #puts path_to.inspect
    begin
      #dup.image = self.image
      #puts self.image.to_file.inspect
      ###########################################################################
      #dup.image = image
      # Копирование файлов быстрее чем dup.image = image

      path_from_to.each_pair do |from_path, to_path|
        #puts "copy " + from_path + " to " + to_path
        dir_name = File.dirname(to_path)
        if FileTest::exist?(from_path)
          FileUtils.makedirs(dir_name)
          FileUtils.copy(from_path, to_path)
        end
      end
      
#      image.styles.each_pair do |k, v|
#        dir_name = File.dirname(dup.image.path(k))
#        if FileTest::exist?(image.path(k))
#          FileUtils.makedirs(dir_name)
#          FileUtils.copy(image.path(k), dup.image.path(k))
#        end
#        puts k
#        puts image.path
#        puts dup.image.path
#        puts image.path(k)
#        puts dup.image.path(k)
#      end
      #puts "==================================================================="
      dup.save
    rescue
      puts "make image copy ERROR!!!!!!!!!!!!!!!!!"
    #  dup.image = nil
    #  return nil
    end

    return dup
  end

  def self.remove_unassigned_images
    conditions = ["az_design_id < 1 AND created_at < DATE_ADD(Now(), INTERVAL -12 HOUR)"]
    images_to_remove = AzImage.find(:all, :conditions => conditions)
    images_to_remove.each do |img|
      img.destroy
    end
  end

  def get_project_over_block
    if az_design == nil
      return nil
    end
    return az_design.get_project_over_block
  end

  def get_label_for_activity
    return "Изображения для дизайна #{az_design.get_label_for_activity}"
  end

  def self.get_model_name
    return 'Изображение'
  end

end

