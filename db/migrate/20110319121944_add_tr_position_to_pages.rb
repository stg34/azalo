class AddTrPositionToPages < ActiveRecord::Migration
  def self.up
    add_column  :az_pages, :tr_position, :integer
  end

  def self.down
    remove_column  :az_pages, :tr_position
  end
end
