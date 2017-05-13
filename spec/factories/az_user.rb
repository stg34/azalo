FactoryGirl.define do
  factory :az_user do
    name                  Forgery(:name).title
    login                 Forgery(:basic).password
    email                 Forgery('email').address
    password              '1234567890'
    password_confirmation '1234567890'
    lastname              Forgery(:name).title
  end
end
