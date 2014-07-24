require 'rails_helper'

describe RacesManager do
  
  let(:manager) { RacesManager.new }
  let(:race)  { FactoryGirl.create(:race, user_id: 1) }
  let(:race2) { FactoryGirl.create(:race, user_id: 2) }
  let(:race3) { FactoryGirl.create(:race, user_id: 1) }
  let(:race4) { FactoryGirl.create(:race, user_id: 2) }
  let(:race5) { FactoryGirl.create(:race, user_id: 1) }
  let(:race6) { FactoryGirl.create(:race, user_id: 1) }
  let(:user)  { FactoryGirl.create(:user, id: 1) }
  let(:user2) { FactoryGirl.create(:user, id: 2) }

  describe 'get_pb_races(a_user) method' do
    # test before adding race times that no PBs are returned.
    context 'where no race times exist' do

      it 'should not return any races if no finish times exist' do
        manager.get_pb_races(user).should eq([])
      end
    end

    context 'where race times exist' do
      
      before(:each) do
        race.finish_time = "2000-01-01 01:33:45"
        race3.finish_time = "2000-01-01 01:30:45"
        race2.finish_time = "2000-01-01 00:59:59"
        race4.finish_time = "2000-01-01 00:59:59"
        race4.distance = "Half Marathon"
        race4.save
        race2.save
        race.save
        race3.save
      end

      it 'should return only the fastest race for a distance' do
        race_array = []
        race_array << race3
        manager.get_pb_races(user).should eq(race_array)
      end

      it 'should not return a race for another user' do
        race_array = []
        race_array << race2
        manager.get_pb_races(user).should_not eq(race_array)
      end

      it 'should return multiple races where there is more than one distance' do
        manager.get_pb_races(user2).size.should eq(2)
      end
    end
  end

  describe 'get_distance_races method(a_user, a_distance)' do 
    context 'where no races with finish times at the distance exist' do

      it 'should not return any races' do
        manager.get_distance_races(user, "10km").should be_empty
      end
    end

    context 'where races with finish times at multiple distances exist' do

      before(:each) do
        race.finish_time = "2000-01-01 01:33:45"
        race3.finish_time = "2000-01-01 01:30:45"
        race5.finish_time = "2000-01-01 01:30:45"
        race5.distance = "Half Marathon"
        race.save
        race3.save
        race5.save
      end

      it 'should only return races for that distance and user' do
        the_race_array = manager.get_distance_races(user, "10km")
        the_race_array.size.should eq(2)
        the_race_array.each do |r|
          r.distance.should eq("10km")
          r.user_id.should eq(user.id)
        end
      end

      it 'should only return races with finish times' do
        the_race_array = manager.get_distance_races(user, "10km")
        the_race_array.each do |r|
          r.finish_time.should be > "2000-01-01 00:00:00"
        end
      end
    end
  end

  describe 'build_completed_race_index(a_user) method' do
    
    before(:each) do
      race.finish_time = "2000-01-01 01:33:45"
      race3.finish_time = "2000-01-01 01:30:45"
      race5.finish_time = "2000-01-01 01:30:45"
      race5.distance = "Half Marathon"
      race.save
      race3.save
      race5.save
    end

    it 'should return races' do
      the_race_array = manager.build_completed_race_index(user)
      the_race_array.size.should be > 0
    end

    it 'should only return races with finish times' do
      the_race_array = manager.build_completed_race_index(user)
      the_race_array.each do |each_race|
        each_race.finish_time.should be >  ("2000-01-01 00:00:00")
      end
    end

    it 'should only return races for the user' do
      the_race_array = manager.build_completed_race_index(user)
      the_race_array.each do |each_race|
        each_race.user_id.should eq(user.id)
      end
    end
  end
  
  describe 'build_upcoming_race_index(a_user) method' do
    before(:each) do
      race.finish_time = "2000-01-01 01:33:45"
      race.save
      race2.save
      race3.save
      race5.save
    end

    it 'should return the correct amount of races' do
      the_race_array = manager.build_upcoming_race_index(user)
      the_race_array.size.should be == 2
    end

    it 'should only return races for the correct user' do
      the_race_array = manager.build_upcoming_race_index(user)
      the_race_array.each do |each_race|
        each_race.user_id.should eq(user.id)
      end
    end
  end
end