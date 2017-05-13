class AddPositionToVariables < ActiveRecord::Migration
  def self.up
    add_column :az_variables, :position, :integer

    Authorization.current_user = AzUser.find_by_login('admin')
    vars = AzVariable.find(:all, :order => "az_struct_data_type_id")
    struct_id = -1
    position = 0
    vars.each do |var|
      puts var.id.to_s + " " + var.name
      if struct_id != var.az_struct_data_type_id
        struct_id = var.az_struct_data_type_id
        position = 0
      end

      var.position = position
      position += 1
      var.save

    end

  end

  def self.down
    remove_column :az_variables, :position
  end
end
