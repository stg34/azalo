class CreateAzMailingHeaderFooter < ActiveRecord::Migration
  def self.up
    create_table "az_mailing_header_footer" do |t|
      t.text     :header,                      :null => false
      t.text     :footer,                      :null => false
    end
  end

  def self.down
    drop_table "az_mailing_header_footer"
  end
end
