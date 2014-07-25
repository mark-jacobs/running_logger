require 'rails_helper'

describe Log do

  let(:log)  { FactoryGirl.create(:log) }
  let(:log2) { FactoryGirl.build(:log) }

  describe 'a log' do

    it 'has a valid factory' do
      log.should be_valid
    end

    it 'is not valid without a date' do
      log.log_date = nil
      log.should_not be_valid
    end

    it 'must have a unique date' do
      log2.log_date = log.log_date
      log2.should_not be_valid
    end

    it 'is not valid with log_miles < 0' do
      log2.log_miles = -1
      log2.should_not be_valid
    end

    it 'is valid with a log miles of 0' do
      log2.log_miles = 0 
      log2.should be_valid
    end
   
    it 'is valid with a log miles of 100' do
      log2.log_miles = 100
      log2.should be_valid
    end

    it 'is not valid with a log_miles > 100' do
      log2.log_miles = 101
      log2.should_not be_valid
    end

    it 'is not valid with plan_miles < 0' do 
      log2.plan_miles = -1
      log2.should_not be_valid
    end

    it 'is valid with a plan_miles of 0' do
      log2.plan_miles = 0 
      log2.should be_valid
    end

    it 'is valid with a plan_miles of 100' do
      log2.plan_miles = 100
      log2.should be_valid
    end

    it 'is not valid with a plan_miles > 100' do
      log2.plan_miles = 101
      log2.should_not be_valid
    end
  end
end