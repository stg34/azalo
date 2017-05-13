FactoryGirl.define do
  factory :az_tariff do
    name                  Forgery(:name).title
    price                 10
    quota_disk            10000000
    quota_active_projects 100
    quota_employees       100
    tariff_type           AzTariff::Tariff_common
    sequence(:position) { |n| n }
  end
end
