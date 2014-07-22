require 'rails_helper'

describe CommonManager do 

  let(:manager) { CommonManager.new }

  describe 'startperiod(number) method' do 

    it 'should return a Monday' do
      manager.startperiod(0).wday.should eq(1)
    end 

    it 'should return the previous Monday when the number of weeks arg is 0' do
      manager.startperiod(0).beginning_of_day.should eq((Time.now - (Time.now.wday - 1).day).beginning_of_day)
    end

    it 'should return next monday when number of weeks arg is 1' do
      manager.startperiod(1).beginning_of_day.should eq((Time.now - (Time.now.wday - 1).day).beginning_of_day + 1.week)
    end

    it 'should return the previous monday 52 weeks in advance when weeks arg is 52' do
      manager.startperiod(52).beginning_of_day.should eq((Time.now - (Time.now.wday - 1).day).beginning_of_day + 52.weeks)
    end
  end

  describe 'endperiod(number) method' do
    
    it 'should return a Monday' do
      manager.endperiod(0).wday.should eq(1)
    end

    it 'should return next Monday when number of weeks arg is 0' do
      manager.endperiod(0).beginning_of_day.should eq((Time.now - (Time.now.wday - 1).day).beginning_of_day + 1.week)
    end

    it 'should return the monday after next monday when number of weeks arg is 1' do
      manager.endperiod(1).beginning_of_day.should eq((Time.now - (Time.now.wday - 1).day).beginning_of_day + 2.weeks)
    end

    it 'should return the next monday 52 weeks in advance when weeks arg is 52' do
      manager.endperiod(52).beginning_of_day.should eq((Time.now - (Time.now.wday - 1).day).beginning_of_day + 53.weeks)
    end
  end
end

