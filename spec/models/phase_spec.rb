require 'rails_helper'

RSpec.describe Phase, :type => :model do
  before (:each) do 
    phase = FactoryGirl.create :phase
    
    it "should be valid" do
      expect(phase).to be_valid
    end

    it "should have a starting date of asdfdsfasdf" do
      expect(phase).to_not be_valid
    end
  end
end
