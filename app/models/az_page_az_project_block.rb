class AzPageAzProjectBlock < ActiveRecord::Base
  #TODO добавить owner-а

  belongs_to :az_page
  belongs_to :az_project_block, :foreign_key => :az_base_project_id

  after_destroy :destroy_blocks

  def destroy_blocks
    if az_project_block != nil && az_project_block.az_page_az_project_blocks.size == 0
      az_project_block.destroy
    end
  end

end
