FactoryGirl.define do
  factory :az_page do
    # sequence(:iata) { |i| %w(AA BB CC DD EE FF GG HH)[i-1] }
    name Forgery(:name).title
    # short_name Forgery(:name).title
    # airline_type Forgery(:name).title.last(5)
  end
end