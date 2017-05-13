FactoryGirl.define do

  factory :az_project do
    name              Forgery(:name).title
    owner             { create :az_company }
    az_project_status { create :az_project_status }
  end
end
