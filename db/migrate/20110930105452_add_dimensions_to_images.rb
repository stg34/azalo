class AddDimensionsToImages < ActiveRecord::Migration
  def self.up
    Authorization.current_user = AzUser.find_by_login('admin')

    add_column  :az_images, :tiny_image_width, :integer, :null => false, :default => 50
    add_column  :az_images, :tiny_image_height, :integer, :null => false, :default => 75

    #ENV['CLASS'] = "AzImage"
    #Rake::Task['paperclip:refresh'].invoke
    # rake paperclip:refresh CLASS=AzImage
    images = AzImage.find(:all)
    images.each do |image|
      if image.image.to_file(:tiny)
        puts "#{image.id}"
        geo = Paperclip::Geometry.from_file(image.image.to_file(:tiny))
        image.tiny_image_width = geo.width
        image.tiny_image_height = geo.height
        image.save!
      end
    end
  end

  def self.down
    remove_column  :az_images, :tiny_image_width
    remove_column  :az_images, :tiny_image_height
  end
end
