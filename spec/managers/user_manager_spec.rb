require 'rails_helper'
require 'spec_helper'

describe UsersManager do

  let(:manager) { UsersManager.new }
  let(:user)    { FactoryGirl.create(:user) }
  let(:user2)   { FactoryGirl.create(:user, id: 2) }
  let(:log1)     { FactoryGirl.create(:log) }
  let(:log2)    { FactoryGirl.create(:log) }
  let(:log3)    { FactoryGirl.create(:log, log_date:(Time.now - 1.year)) }
  let(:log4)    { FactoryGirl.create(:log, user_id: 2) }

  


end