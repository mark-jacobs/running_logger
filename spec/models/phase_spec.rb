require 'rails_helper'

describe Phase do 

  let(:user) { FactoryGirl.create(:user, :with_phase, :with_second_phase) }

  describe 'a phase' do 

    it 'has a valid factory' do
      user.phases.find(1).should be_valid
    end

    it 'is not valid without a start_date' do
      the_phase = user.phases.find(1)
      the_phase.start_date = nil
      the_phase.should_not be_valid
      the_phase.errors.count.should eq(1)
    end

    it 'is not valid without a target_date' do
      the_phase = user.phases.find(1)
      the_phase.target_date = nil
      the_phase.should_not be_valid
      the_phase.errors.count.should eq(2)
    end

    it 'is not valid when the target_date is earlier than the start_date' do
      the_phase = user.phases.find(1)
      the_phase.target_date = Time.now - 1.day
      the_phase.start_date = Time.now
      the_phase.should_not be_valid
      the_phase.errors.count.should eq(1)
    end

    it 'is not valid when the period overlaps another phase' do
      the_phase = user.phases.find(1)
      the_phase.start_date = "2013-08-01 00:00:00"
      the_phase.should_not be_valid
      the_phase.errors.count.should eq(1)

    end
  end
end

