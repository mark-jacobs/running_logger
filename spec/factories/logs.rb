# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :log do |f|
    f.log_date Time.now + 1.day
  end
end