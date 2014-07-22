require 'rails_helper'

describe UsersManager do
  
  let(:user)  { FactoryGirl.create(:user, id: 1) }
  let(:user2) { FactoryGirl.create(:user, id: 2) }
  let(:log)   { FactoryGirl.create(:log) }
  let(:log2)  { FactoryGirl.create(:log) }
  let(:log3)  { FactoryGirl.create(:log) }


end