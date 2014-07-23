require 'rails_helper'

describe PhasesManager do 
  
  let (:manager)    { PhasesManager.new }
  let (:user)       { FactoryGirl.create(:user, :with_phase) }
  let (:phase_inv)  { FactoryGirl.build(:phase_invalid) }
  let (:phase)      { FactoryGirl.build(:phase) }
  let (:user_build) { FactoryGirl.create(:user, :with_invalid_phase) }

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
end