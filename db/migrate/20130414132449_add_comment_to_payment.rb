class AddCommentToPayment < ActiveRecord::Migration
  def self.up
    add_column :az_payments, :comment, :string, :default => ''
  end

  def self.down
    remove_column :az_payments, :comment
  end
end
