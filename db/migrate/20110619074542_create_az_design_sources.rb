class CreateAzDesignSources < ActiveRecord::Migration
  def self.up

    Authorization.current_user = AzUser.find_by_login('admin')

    create_table :az_design_sources do |t|
      t.integer   :az_design_id,         :null => false
      t.string    :source_file_name,     :null => false
      t.string    :source_content_type,  :null => false
      t.integer   :source_file_size,     :null => false
      t.datetime  :source_updated_at,    :null => false
      t.integer   :owner_id,             :null => false
      t.timestamps
    end

    #begin
    designs = AzDesign.all
    designs.each do |design|
      #begin
        if design.design_source_file_name != nil
          puts design.id.to_s + " " + design.design_source_file_name + " " + design.design_source_file_size.to_s
          design_source = AzDesignSource.new
          design_source.az_design = design
          design_source.owner_id = design.owner_id
          design_source.source = design.design_source
          begin
            design_source.save
          rescue
            puts "Copy ERROR " + design.id.to_s + " " + design.design_source_file_name + " " + design.design_source_file_size.to_s
          end
          design.design_source = nil
          design.design_tmp_source = nil
          design.save
        end
      #rescue
        #puts "ERROR!!!!!!!!!!!!!!!!!!"
      #end
    end
  end

  def self.down

    Authorization.current_user = AzUser.find_by_login('admin')

    design_sources = AzDesignSource.all
    design_sources.each do |design_source|
      design = AzDesign.find(design_source.az_design_id)
      if design != nil
        puts design_source.source_file_name + " " + design_source.source_file_size.to_s
        design.design_source = design_source.source
        design.save
      end
      design_source.destroy
    end
    drop_table :az_design_sources
  end
end
