class AzDesignSource < ActiveRecord::Base

  attr_accessible :az_design_id, :source_file_name, :source_content_type, :source_file_size, :source_updated_at,
                  :owner_id, :created_at, :updated_at, :copy_of, :az_design, :id

  belongs_to  :az_design
  #has_many    :az_design_sources, :dependent => :destroy

  has_attached_file :source
  belongs_to :owner, :foreign_key => 'owner_id', :class_name => 'AzCompany'

  validates_attachment_size           :source, :in => 1..20.megabytes

  validate :validate_owner_id

  def validate_owner_id
    if !new_record? && az_design.owner_id != owner_id
      errors.add(:base, "Incorrect owner_id value. Design has '#{az_design.owner_id}', DesignSource has '#{owner_id}'")
    end
  end

  def self.from_az_hash(attributes, design_ids_original_copy, company, local_copy = true)
    design_source = AzDesignSource.new(attributes)
    design_source.copy_of = attributes['id']
    design_source.owner = company
    design_source.az_design_id = design_ids_original_copy[attributes['az_design_id']]
    if local_copy
      original_design_source = AzDesignSource.find(design_source.copy_of)
      if original_design_source == nil
        #raise "Design source not found!"
        return nil
      end

      if !FileTest::exist?(original_design_source.source.path)
        return nil
      end

      design_source.source = original_design_source.source
    end
    return design_source
  end

  def make_copy_design_source(design)
    puts "DESIGN_SOURCE MAKE_COPY new_owner_id = #{design.owner.id}"
    dup = self.az_clone
    dup.copy_of = self.id
    dup.az_design = design
    dup.owner = design.owner
    dup.save!
    
    to_path = dup.source.path
    from_path = source.path
    begin
       dir_name = File.dirname(to_path)
        if FileTest::exist?(from_path)
          FileUtils.makedirs(dir_name)
          FileUtils.copy(from_path, to_path)
        end
      #puts "==================================================================="
      dup.save
    rescue
      puts "AzDesignSource make copy ERROR!!!!!!!!!!!!!!!!!"
    end

    return dup
  end

  def get_project_over_block
    if az_design == nil
      return nil
    end
    return az_design.get_project_over_block
  end

  def get_label_for_activity
    return "Исходник дизайна #{az_design.get_label_for_activity}"
  end

end
