require 'rails_helper'
require 'spec_helper'

describe UsersManager do

  let(:manager) { UsersManager.new }
  let(:user)    { FactoryGirl.create(:user, :with_old_logs) }
  let(:user2)   { FactoryGirl.create(:user) }
  let(:user3)   { FactoryGirl.create(:user, :with_logs ) }
  let(:user4)   { FactoryGirl.create(:user, :with_8_weeks_of_logs) }

  describe 'yearly_miles(a_year, a_user) method' do

    it 'should return miles the correct number of miles for the user for the current year' do
      manager.yearly_miles(0, user3).should be == 20
    end

    it 'should return the correct number of miles for the user for the previous year' do
      manager.yearly_miles(1, user).should be == 30
    end

    it 'should not return any miles when the user has no logs' do
      manager.yearly_miles(0, user2).should be == 0
    end
  end

  describe 'create_weekly_miles_array(user) method' do
     
    it 'should create an array with size 8' do
      manager.create_weekly_miles_array(user).size.should be == 8
      # same thing with expect syntax
      expect(manager.create_weekly_miles_array(user4).size).to be == 8
    end

    it 'should have values for each week' do 
      manager.create_weekly_miles_array(user4).each do |element|
        element.should be > 0 
      end
    end
  end
end