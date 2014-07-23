require 'rails_helper'

describe LogsManager do 

  let(:manager)   { LogsManager.new }
  let(:user)      { FactoryGirl.create(:user, :with_current_log, :with_old_logs) }


  describe 'create_logs_array(user, period) method' do
    
    it 'returns logs inside of the period' do
      result = manager.create_logs_array(user, 0)
      result.should_not be_empty
      result.each do |x|
        unless x.nil?
          x.log_date.should_not be < manager.startperiod(0)
          x.log_date.should_not be > manager.endperiod(0)
        end
      end
    end

    it 'returns no logs if no logs in the period' do
      result = manager.create_logs_array(user, 1)
      result.should be_empty
    end
  end
end