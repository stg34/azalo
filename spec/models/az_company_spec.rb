require 'rails_helper'

RSpec.describe AzCompany, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before :all do
    user = create :az_user
    Authorization.current_user = user
  end

  describe '.save!' do
    let(:company)    { build :az_company, ceo: Authorization.current_user }

    it 'should raise validation error when src_id is filled and src_type is empty' do
      # binding.pry
      # expect{ page.id }.not_to raise_error#(ActiveRecord::RecordInvalid)
    end

  end

end
