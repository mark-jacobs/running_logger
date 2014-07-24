require 'rails_helper'

describe User do 

  let(:built_user)    { FactoryGirl.build(:user) }
  let(:created_user)  { FactoryGirl.create(:user) }

  describe 'a user' do
  
    it 'should have a valid factory' do
      built_user.should be_valid
    end

    it 'is not valid with a blank email address' do
      built_user.email = ""
      built_user.should_not be_valid
    end

    it 'is not valid with an email address in an incorrect format' do
      built_user.email = "noway@trythis.com@"
      built_user.should_not be_valid
    end

    it 'is not valid with a name with a length > 50 characters' do
      built_user.name = 'a' * 51
      built_user.should_not be_valid
    end

    it 'is valid with a name with a length < 50 characters' do
      built_user.name = 'a' * 50
      built_user.should be_valid
    end

    it 'is not valid with a blank name' do
      built_user.name = ''
      built_user.should_not be_valid
    end

    it 'is not valid with a password length < 6' do 
      built_user.password = 'frog1'
      built_user.password_confirmation = 'frog1'
      built_user.should_not be_valid
    end

    it 'is not valid with a blank password' do
      built_user.password = ''
      built_user.password_confirmation = ''
      built_user.should_not be_valid
    end

    it 'is not valid if the password and confirmation do not match' do
      built_user.password_confirmation = 'frogglefroggle'
      built_user.should_not be_valid
    end
  end
end
