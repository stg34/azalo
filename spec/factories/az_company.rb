FactoryGirl.define do
  factory :az_company do
    name      Forgery(:name).title
    az_tariff { create(:az_tariff) }
    ceo       { create(:az_user) }
  end
end
