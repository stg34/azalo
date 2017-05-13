module Paperclip
  class Geometry


    # Uses ImageMagick to determing the dimensions of a file, passed in as either a
    # File or path.
    # NOTE: (race cond) Do not reassign the 'file' variable inside this method as it is likely to be
    # a Tempfile object, which would be eligible for file deletion when no longer referenced.
    def self.from_file file
      file_path = file.respond_to?(:path) ? file.path : file
      raise(Paperclip::NotIdentifiedByImageMagickError.new("Cannot find the geometry of a file with a blank name")) if file_path.blank?
      geometry = begin
        Paperclip.run("identify", "-format %wx%h #{file_path}")
      rescue Cocaine::ExitStatusError
        ""
      rescue Cocaine::CommandNotFoundError => e
        raise Paperclip::CommandNotFoundError.new("Could not run the `identify` command. Please install ImageMagick.")
      end
      parse(geometry) ||
        raise(NotIdentifiedByImageMagickError.new("#{file_path} is not recognized by the 'identify' command."))
    end
  end
end