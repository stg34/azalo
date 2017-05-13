class AddIndexToValidators < ActiveRecord::Migration
  def self.up
    add_index :az_validators, :az_variable_id
  end

  def self.down
    remove_index :az_validators, :az_variable_id
  end
end
