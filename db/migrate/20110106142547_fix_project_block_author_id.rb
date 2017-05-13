class FixProjectBlockAuthorId < ActiveRecord::Migration
  def self.up
    blocks = AzProjectBlock.find(:all, :conditions => {:author_id => nil})
    blocks.each do |bl|
      execute("update az_base_projects set author_id = #{bl.owner.ceo_id} where id=#{bl.id}")
    end
  end

  def self.down

  end
end
