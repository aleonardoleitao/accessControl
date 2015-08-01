# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    name "MyString"
    country "MyString"
    city "MyString"
    state "MyString"
    kind 1
    ethnicity "MyString"
    height 1.5
    weight 1.5
    hair_color "MyString"
    hair_style "MyString"
    physical_appearence "MyString"
    eyes_color "MyString"
    smoke false
    education_level "MyString"
    drink false
    tatoo false
    favorite_drink "MyString"
    piercing false
    strengths "MyString"
    about_me "MyString"
    children false
    interested_in 1
    goals "MyString"
    proposal "MyText"
    user nil
  end
end
