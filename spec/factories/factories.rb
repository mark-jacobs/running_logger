FactoryGirl.define do
  
  factory :log do |f|
    f.sequence(:log_date)       { |n| (Time.new("#{Time.now.year}-07-01 00:00:00") + n.days) }
    f.sequence(:plan_workout)   { |n| "Workout #{n}" }
    f.plan_miles                10.0
    f.log_miles                 10.0

    factory :last_years_log do |f|
      f.sequence(:log_date)     { |n| (Time.new("#{Time.now.year}-07-01 00:00:00") + n.days - 1.year) }
    end

    factory :incrementing_logs do |f|
      f.sequence(:log_date)     { |n| (Time.now.beginning_of_day - n.days  + 8.weeks) }
    end
  end

 

  factory :phase do |f|
    f.start_date              "2014-04-01 18:19:56"
    f.target_date             "2014-08-11 18:19:56"
    f.user_id                 1

    factory :phase_invalid do |f|
      f.start_date            "2014-08-12 18:19:56"
    end
  end

  factory :race do |f|
    f.sequence(:race_date)    { |n| Time.now + n.days }
    f.sequence(:race_name)    { |n| "Mega Race#{n}" }
    f.distance                "10km"
    f.finish_time             Time.new("2000-01-01 00:00:00")
    f.position                nil
  end

  factory :user do |f|
    f.sequence(:name)         { |n| "Test Name#{n}" }
    f.sequence(:email)        { |n| "test#{n}@email.com" }
    f.password                "froggle"
    f.password_confirmation   "froggle"

    trait :with_logs do
      after(:create) do |instance|
        create_list :log, 2, user: instance
      end
    end

    trait :with_old_logs do
      after(:create) do |instance|
        create_list :log, 2, user: instance
        create_list :last_years_log, 3, user: instance
      end
    end

    trait :with_8_weeks_of_logs do
      after(:create) do |instance|
        create_list :incrementing_logs, 56, user: instance
      end
    end

    trait :with_phase do
      after(:create) do |instance|
        create_list :phase, 1, user: instance
      end
    end

    trait :with_invalid_phase do
      after(:create) do |instance|
        build_list :phase_invalid, 1, user: instance
      end
    end
  end

end
