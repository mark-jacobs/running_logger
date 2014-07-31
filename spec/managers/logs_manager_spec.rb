require 'rails_helper'

describe LogsManager do 

  let(:manager)   { LogsManager.new }
  let(:user)      { FactoryGirl.create(:user, :with_current_log, :with_old_logs2) }
  let(:user2)     { FactoryGirl.create(:user, :with_current_log, :with_old_logs, :with_race) }
  let(:user3)     { FactoryGirl.create(:user, :with_current_log, :with_old_logs, :with_today_race) }
  let(:user4)     { FactoryGirl.create(:user, :with_current_log, :with_current_phase) }

  describe 'create_logs_array(user, period) method' do
    
    it 'returns logs inside of the period' do
      result = manager.create_logs_array(user, 0)
      result.should_not be_empty
      result.each do |x|
        unless x.nil?
          x.log_date.should_not be < manager.startperiod(0)
          x.log_date.should_not be > manager.endperiod(0)
        end
      end
    end

    it 'returns no logs if no logs in the period' do
      result = manager.create_logs_array(user, 1)
      result.should be_empty
    end
  end

  describe 'get_log_for_edit(user, period, day) method' do
    
    context 'if a log exists for the user, period and day' do
      it 'returns the correct log' do
        log = manager.get_log_for_edit(user, 0, (Time.now).wday)
        log.should_not be_nil
        log.log_date.should be > Time.now.beginning_of_day  
        log.log_date.should be < Time.now.end_of_day
        log.user_id.should eq(user.id)
      end
    end

    context 'if a log does not exist for the user, period and day' do
      it 'returns nil' do
        log = manager.get_log_for_edit(user, 1, (Time.now).wday)
        log.should be_nil
      end
    end
  end

  describe 'build_log(user, period, day) method' do

    context 'with valid information' do

      it 'should be valid' do
        manager.build_log(user, 1, 1).should be_valid
      end

      it "sets log time  to \"00:00:00\"" do
        log = manager.build_log(user, 0, 1)
        log.log_time.should eq("2000-01-01 00:00:00.000000000 +0000")
      end

      it 'sets log date to the correct day' do
        log = manager.build_log(user, 0, 1)
        test_date = Time.now - Time.now.wday.days + 1.day
        log.log_date.monday?.should be_truthy
        log.log_date.to_date.should eq(test_date.to_date)
      end
    end
  end

  describe 'races_in_period(user, period) method' do

    context 'when there are no races for user in the period' do

      it 'returns an empty array' do
        manager.races_in_period(user, 0).should eq([])
      end
    end

    context 'when there are races for the user in the period' do

      it 'returns an array with the races' do
        races_array = manager.races_in_period(user3,0)
        races_array.include?(user2.races.find(2))
      end

      it 'should be in the correct element in the array for its day' do
        races_array = manager.races_in_period(user3,0)
        7.times do |count|
          unless races_array[count].nil?
            if Time.now.wday == 0
              races_array[count].race_date.wday.should eq(6)
            else
              races_array[count].race_date.wday.should eq(Time.now.wday)
            end
          end
        end
      end
    end
  end

  describe 'get_race_for_log_day(user, period, day) method' do
    
    context 'when a race exists on the day' do
    
      it 'returns the correct race' do
        the_race = manager.get_race_for_log_day(user3, 0, Time.now.wday)
        the_race.race_date.to_date.should eq(Time.now.to_date)
      end
    end

    context 'when a race does not exist on the day' do

      it 'returns nil' do
        the_race = manager.get_race_for_log_day(user3, 0, Time.now.wday - 1.day)
        the_race.should be_nil
      end
    end
  end

  describe 'generate_summary(logs) method' do

    context 'when there are no logs in the period' do

      it 'returns 0 values for the summary' do
        logs = manager.create_logs_array(user, -2)
        summary = manager.generate_summary(logs)
        summary[:planned_miles].should eq(0)
        summary[:logged_miles].should eq(0)
        summary[:logged_calories].should eq(0)
        summary[:logged_time].should eq(0)
      end
    end

    context 'when there are logs in the period' do

      it 'returns correct values for the summary' do
        logs = manager.create_logs_array(user, 0)
        summary = manager.generate_summary(logs)
        summary[:planned_miles].should eq(15)
        summary[:logged_miles].should eq(12)
        summary[:logged_calories].should eq(1000)
        summary[:logged_time].should eq(1260)
      end
    end
  end

  describe 'get_current_phase(user, period) method' do
    
    context 'when there is a current phase' do
      
      it 'returns the current phase as a string'  do
        manager.get_current_phase(user4, 0).should eq("Phase III")
        manager.get_current_phase(user4, 6).should eq("Phase IV")
        manager.get_current_phase(user4, -3).should eq("Phase II")
        manager.get_current_phase(user4, -6).should eq("Phase I")
      end
    end

    context 'when there is no current phase' do

      it "returns \"No Phase\"" do
        manager.get_current_phase(user, 0).should eq("No Phase")
      end
    end
  end
end