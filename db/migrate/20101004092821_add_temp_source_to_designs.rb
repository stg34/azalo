class AddTempSourceToDesigns < ActiveRecord::Migration
  def self.up
    add_column :az_designs,  :design_tmp_source_file_name,    :string
    add_column :az_designs,  :design_tmp_source_content_type, :string
    add_column :az_designs,  :design_tmp_source_file_size,    :integer
    add_column :az_designs,  :design_tmp_source_updated_at,   :datetime
    add_column :az_designs,  :design_tmp_source_magic,        :integer
  end

  def self.down
    remove_column :az_designs,  :design_tmp_source_file_name
    remove_column :az_designs,  :design_tmp_source_content_type
    remove_column :az_designs,  :design_tmp_source_file_size
    remove_column :az_designs,  :design_tmp_source_updated_at
    remove_column :az_designs,  :design_tmp_source_magic
  end
end
