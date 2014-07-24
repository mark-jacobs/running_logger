require 'rails_helper'

describe Race do

  describe 'a race' do

    let(:user)    { FactoryGirl.create(:user, :with_race)}

    it 'has a valid factory' do
      user.races.find(1).should be_valid
    end

    it 'is not valid without a race_date' do
      the_race = user.races.find(1)
      the_race.race_date = nil
      the_race.should_not be_valid
    end

    it 'is not valid without a race_name' do
      the_race = user.races.find(1)
      the_race.race_name = nil
      the_race.should_not be_valid
    end

    it 'is not valid with a blank race_name' do
      the_race = user.races.find(1)
      the_race.race_name = ''
      the_race.should_not be_valid
    end
  end 
end
