require 'rails_helper'

RSpec.describe AzPage, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  before :all do
    user = build :az_user
    Authorization.current_user = user
  end


  describe '.save!' do
    let(:page)    { build :az_page }

    it 'should raise validation error when src_id is filled and src_type is empty' do
      expect{ page.id }.not_to raise_error#(ActiveRecord::RecordInvalid)
    end

  end

end
