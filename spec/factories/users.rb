# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user do
    username { Faker::InternetSE.login_user_name }
    email { Faker::InternetSE.email }
    password { Faker::Lorem.words.join }
    terms_accepted true
    confirmed_at { 1.minute.ago }
  end
end
