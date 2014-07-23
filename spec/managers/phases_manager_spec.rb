require 'rails_helper'

describe PhasesManager do 
  
  let (:manager)      { PhasesManager.new }
  let (:user)         { FactoryGirl.create(:user, :with_phase) }
  let (:second_user)  { FactoryGirl.create(:user, :with_phase) }
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

      it 'should adjust the target period to the next Sunday if not already a Sunday'
        phase_params = {}

    end
  end
end