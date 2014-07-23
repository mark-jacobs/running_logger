require 'rails_helper'

describe PhasesManager do 
  
  let (:manager)      { PhasesManager.new }
  let (:user)         { FactoryGirl.create(:user, :with_phase) }
  let (:second_user)  { FactoryGirl.create(:user, :with_phase, :with_second_phase) }
  let (:phase_inv)    { FactoryGirl.build(:phase_invalid) }
  let (:phase)        { FactoryGirl.build(:phase) }
  let (:user_build)   { FactoryGirl.create(:user, :with_invalid_phase) }

  describe 'create_phase(phase) method' do

    context 'with invalid dates' do

      it 'should return false' do
        phase_inv.save.should eq(false)
      end
    end

    context 'with valid dates' do

      it 'should return true' do
        phase.save.should eq(true)
      end
    end
  end

  describe 'update_phase(phase) method' do

    context 'with valid data' do

      it 'should return true' do
        phase_params = { start_date: "2014-03-01 18:19:56" }
        manager.update_phase(phase, phase_params).should eq(true)
      end

      it 'should adjust the start period to the next Monday if not already a Monday' do
        phase_params = { start_date: "2014-03-01 18:19:56" }
        manager.update_phase(phase, phase_params)
        phase.start_date.should eq("2014-03-03 18:19:56")
      end
      
      it 'should not adust the start period if already a Monday' do
        phase_params = { start_date: "2014-02-24 18:19:56" }
        manager.update_phase(phase, phase_params)
        phase.start_date.should eq("2014-02-24 18:19:56")
      end

      it 'should adjust the target period to the next Sunday if not already a Sunday' do
        phase_params = { target_date: "2014-02-10 18:19:56" }
        manager.update_phase(phase, phase_params)
        phase.target_date.should eq("2014-02-16 18:19:56")
      end

      it 'should not adjust the target period to the next Sunday if already a Sunday' do
        phase_params = { target_date: "2014-02-16 18:19:56" }
        manager.update_phase(phase, phase_params)
        phase.target_date.should eq("2014-02-16 18:19:56")
      end
    end

    context 'with invalid data' do

      it 'should return false' do
        phase_params = { start_date: "2015-03-01 18:19:56" }
        manager.update_phase(phase, phase_params).should eq(false)
      end
    end
  end

  describe 'get_phase_weeks(phases) method' do

    it 'should return an array with a size equal to the number of phases for the user' do
      manager.get_phase_weeks(second_user.phases.all).size.should eq(2)
      manager.get_phase_weeks(user.phases.all).size.should eq(1)
    end

    it 'should return an array that contains the correct value for the number of weeks for each of the phases' do
      test_array = manager.get_phase_weeks(second_user.phases.all)
      test_array[0].should eq(19)
      test_array[1].should eq(14)
    end
  end
end