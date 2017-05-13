class ChangeDescriptionInVariable < ActiveRecord::Migration
  def self.up
    change_column :az_variables, :description, :text
  end

  def self.down
    change_column :az_variables, :description, :string
  end
end
