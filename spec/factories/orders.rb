# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    uuid "MyString"
    payer_data "MyText"
    payment_reason "MyString"
    value ""
    api_call_response "MyText"
    nasp_responses "MyText"
  end
end
