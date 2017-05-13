require 'rubygems'
require 'RMagick'

module Paperclip
  class Borderer < Thumbnail
  #class Cropper < Paperclip::Processor
    #def transformation_command
    #  crop_command
    #end

    def make
      src = @file
      #attach = @attachment
      #path = attach.path
      image = Magick::Image.read(File.expand_path(src.path)).first
      #image = Magick::Image.read(File.expand_path(@attachment.path)).first

      # Create Templfile object and write image data to its file
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode

      w = Paperclip::Geometry.parse(options[:geometry]).width
      h = Paperclip::Geometry.parse(options[:geometry]).height

      #w_big = (w * 1.5).ceil
      #h_big = (h * 1.5).ceil

      border_width = 1
      w = w - 2 * border_width
      h = h - 2 * border_width

      #image = image.resize_to_fill(w, h)
      #image = image.border(border_width, border_width, 'silver')

      image.resize_to_fit!(w, h)
      image.border!(border_width, border_width, 'silver')

      image.write(File.expand_path(dst.path))
      # Return Tempfile object to Paperclip for further handling
      return dst
    end


#    def crop_command
#      w = Paperclip::Geometry.parse(options[:geometry]).width
#      h = Paperclip::Geometry.parse(options[:geometry]).height
#
#      w_big = (w * 1.5).ceil
#      h_big = (h * 1.5).ceil
#
#      border_width = 1
#      w = w - 2 * border_width
#      h = h - 2 * border_width
#
#      #puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
#      #puts " -resize #{w_big}x#{h_big}^ -crop #{w}x#{h}+0+0 -bordercolor silver -border #{border_width} "
#
#      #return " -resize #{w_big}x#{h_big}^ -crop #{w}x#{h}+0+0 -bordercolor silver -border #{border_width} "
#      return [" -resize #{w_big}x#{h_big}^" ] + ["-crop #{w}x#{h}+0+0"] + ["-bordercolor silver"] + ["-border #{border_width} "]
#      #return "-resize 75x113^"
#    end
  end
end
