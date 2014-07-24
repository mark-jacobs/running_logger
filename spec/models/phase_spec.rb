require 'rails_helper'

describe Phase do 

  let(:user) { FactoryGirl.create(:user, :with_phase) }

  describe 'a phase' do 

    it 'has a valid factory' do
      user.phases.find(1).should be_valid
    end

    it 'is not valid without a start_date' do
      the_phase = user.phases.find(1)
      the_phase.start_date = nil
      the_phase.should_not be_valid
    end
  end
end

