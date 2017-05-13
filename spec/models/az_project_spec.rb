require 'rails_helper'

RSpec.describe AzProject, :type => :model do

  fixtures :az_project_statuses
  fixtures :az_tariffs
  fixtures :az_commons

  before :all do

  end

  describe '.save!' do

    it 'foo bar' do

      user = create :az_user
      Authorization.current_user = user

      az_company = create :az_company, ceo: user
      project = AzProject.create('name', az_company, az_company.ceo)

      pp project
      binding.pry

      # expect{ page.id }.not_to raise_error#(ActiveRecord::RecordInvalid)
    end

  end

end
