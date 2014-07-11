# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phase do
    start_date "2014-07-11 18:19:56"
    target_date "2014-07-11 18:19:56"
    user_id 1
    include_phase_I false
  end
end
