class AddDisabledToEmployees < ActiveRecord::Migration
  
  def self.up
      add_column 'az_employees', :disabled,  :boolean, :null => false, :default => false
  end

  def self.down
      remove_column 'az_employees', :disabled
  end
end
