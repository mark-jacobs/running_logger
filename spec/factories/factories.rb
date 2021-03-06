FactoryGirl.define do
  
  factory :log do |f|
    f.sequence(:log_date)       { |n| (Time.parse("#{Time.now.year}-07-01 00:00:00") + n.days) }
    f.sequence(:plan_workout)   { |n| "Workout #{n}" }
    f.plan_miles                15.0
    f.log_miles                 10.0
    f.log_calories              1000
    f.log_time                  "00:21:00"


    factory :last_years_log do |f|
      f.sequence(:log_date)     { |n| (Time.parse("#{Time.now.year}-07-01 00:00:00") + n.days - 1.year) }
    end

    factory :incrementing_logs do |f|
      f.sequence(:log_date)     { |n| (Time.now.beginning_of_day - n.days  + 8.weeks) }
    end

    factory :current_log do |f|  
      f.log_date              Time.now
      f.log_miles             12
    end
  end
  
  factory :phase do |f|
    f.start_date              "2014-04-01 18:19:56"
    f.target_date             "2014-08-11 18:19:56"
    f.user_id                 1

    factory :phase_invalid do |f|
      f.start_date            "2014-08-12 18:19:56"
    end

    factory :second_phase do |f|
      f.start_date             "2013-05-01 18:19:56"
      f.target_date            "2013-08-11 18:19:56"
    end

    factory :current_phase do |f|
      f.start_date             Time.now - 8.weeks
      f.target_date            Time.now + 8.weeks
    end
  end

  factory :race do |f|
    f.sequence(:race_date)    { |n| Time.now + n.days }
    f.sequence(:race_name)    { |n| "Mega Race#{n}" }
    f.distance                "10km"
    f.finish_time             Time.new("2000-01-01 00:00:00")
    f.position                nil
    f.user_id                 1

    factory :race_today do |f|
      f.race_date             Time.now
    end
  end

  factory :user do |f|
    f.sequence(:name)         { |n| "Test Name#{n}" }
    f.sequence(:email)        { |n| "test#{n}@email.com" }
    f.id                      { |n| n }
    f.password                "froggle"
    f.password_confirmation   "froggle"

    factory :second_user do |f|
      f.id                     2
    end

    trait :with_logs do
      after(:create) do |instance|
        create_list :log, 2, user: instance
      end
    end

    trait :with_current_log do
      after(:create) do |instance|
        create_list :current_log, 1, user: instance
      end
    end

    trait :with_built_log do 
      after(:create) do |instance|
        build_list :current_log, 1, user: instance
      end
    end

    trait :with_old_logs do
      after(:create) do |instance|
        create_list :log, 2, user: instance
        create_list :last_years_log, 3, user: instance
      end
    end

    trait :with_old_logs2 do
      after(:create) do |instance|
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

    trait :with_second_phase do
      after(:create) do |instance|
        create_list :second_phase, 1, user:instance
      end
    end

    trait :with_invalid_phase do
      after(:create) do |instance|
        build_list :phase_invalid, 1, user: instance
      end
    end

    trait :with_race do
      after(:create) do |instance|
        create_list :race, 1, user: instance
      end
    end

    trait :with_today_race do
      after(:create) do |instance|
        create_list :race_today, 1, user: instance
      end
    end

    trait :with_current_phase do
      after(:create) do |instance|
        create_list :current_phase, 1, user: instance
      end
    end
  end
end
