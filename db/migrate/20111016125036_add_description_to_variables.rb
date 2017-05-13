class AddDescriptionToVariables < ActiveRecord::Migration
  def self.up
    add_column :az_variables, :description, :string, :default => ''
  end

  def self.down
    remove_column :az_variables, :description
  end
end
