require 'rails_helper'

RSpec.describe AzUser, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe '.save!' do
    let(:user)    { build :az_user }

    it 'should raise validation error when src_id is filled and src_type is empty' do

      # expect{ page.id }.not_to raise_error#(ActiveRecord::RecordInvalid)
    end

  end

end
