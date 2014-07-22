FactoryGirl.define do
  
  factory :log do |f|
    f.sequence(:log_date)     { |n| (Time.now + n.days).beginning_of_day }
    f.sequence(:plan_workout)    { |n| "Workout #{n}" }
    f.plan_miles              10.0
    f.log_miles               10.0
    f.user_id                 1
  end

  factory :phase do |f|
    f.start_date              "2014-07-01 18:19:56"
    f.target_date             "2014-08-11 18:19:56"
    f.user_id                 1
  end

  factory :race do |f|
    f.sequence(:race_date)    { |n| Time.now + n.days }
    f.sequence(:race_name)    { |n| "Mega Race#{n}" }
    f.distance                "10km"
    f.finish_time             Time.new("2000-01-01 00:00:00")
    f.position                nil
    f.user_id                 1
  end

  factory :user do |f|
    f.sequence(:name)         { |n| "Test Name#{n}" }
    f.sequence(:email)        { |n| "test#{n}@email.com" }
    f.password                "froggle"
    f.password_confirmation   "froggle"
    f.id                      1
  end

end
