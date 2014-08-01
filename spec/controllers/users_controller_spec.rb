require 'rails_helper'
require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  
  let!(:user)  { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }
  let(:user2)  { FactoryGirl.build(:user) }

  describe 'new user action' do
    
    context 'when user is signed in' do
      before(:each) { sign_in user, no_capybara: true }
    
      it 'redirects to the root url' do
        expect(get :new, use_route: 'signup').to redirect_to root_url
      end
    end

    context 'when user is not signed in' do
      
      it 'it renders the users/new template' do
        expect(get :new, use_route: 'signup').to render_template('users/new')
      end
    end 
  end

  describe 'create user action' do 

    context 'when user is signed in' do
      before(:each) { sign_in user, no_capybara: true }

      it 'redirects to the root url' do
        expect(post :create ).to redirect_to root_url
      end    
    end

    context 'when user is not signed in' do

      context 'with valid data' do
        
        it 'creates a new user' do
          expect{post :create, 
            user: { name: 'Ronald McDonald', email: "f@g.com", password: "froggle", password_confirmation: "froggle"}}.to change{User.count}.by(1)
        end
      end

      context 'when email already exists' do

        it 'does not change the User count' do
          expect{post :create, 
            user: { name: 'Ronald McDonald', email: "#{User.first.email}", password: "froggle", password_confirmation: "froggle"}
                   }.to change{User.count}.by(0)
        end

        it 'renders the users/new template' do
          expect(post :create, 
            user: { name: 'Ronald McDonald', email: "#{User.first.email}", password: "froggle", password_confirmation: "froggle"}
                   ).to render_template('users/new')
        end
      end

      context 'when the password and password_confirmation do not match' do

        it 'does not change the User count' do
          expect{post :create, 
            user: { name: 'Ronald McDonald', email: "f@g.com", password: "froggle", password_confirmation: "frogglefroggle"}
                   }.to change{User.count}.by(0)
        end
        
        it 'renders the users/new template' do
          expect(post :create, 
            user: { name: 'Ronald McDonald', email: "f@g.com", password: "froggle", password_confirmation: "frogglefroggle"}
                   ).to render_template('users/new')
        end
      end
    end
  end

  describe 'show user action' do 

    context 'when user is signed in' do
      before(:each) { sign_in user, no_capybara: true } 

      it 'renders the users/show template when passed the current users id' do
        expect(get :show, id: user.id).to render_template('users/show')
      end

      it 'redirects to root url when passed a non existent users id' do
        expect(get :show, id: User.last.id + 1).to redirect_to root_url
      end
 
      it 'redirects to root url when passed another users id' do
        expect(get :show, id: user3.id).to redirect_to root_url
      end
    end

    context 'when user is not signed in' do

      it 'redirects to the root url' do
        expect(get :show, id: user.id).to redirect_to signin_url
      end
    end
  end

  describe 'update user action' do 

    context 'when user is signed in' do
      before(:each) { sign_in user, no_capybara: true }

      context 'with valid information' do
        before(:each) { patch :update, id: user.id, user: { name: "larkin", email: "a@t.com", password: "froggle", password_confirmation: "froggle" } }
        
        it 'updates the user' do
          expect(User.find(user.id).name).to eq("larkin")
        end

        it 'redirects to the user profile' do
          expect(response).to redirect_to user_url
        end
      end

      context 'with invalid information' do

        it 'renders the edit page' do
          expect(patch :update, id: user.id, 
            user: { name: "larkin", email: "at.com", password: "froggle", password_confirmation: "froggle" }).to render_template('users/edit')
        end
      end  
    end

    context 'when user is not signed in' do

      it 'redirects to the root_url' do
        expect(patch :update, id: user.id, 
          user: { name: "larkin", email: "a@t.com", password: "froggle", password_confirmation: "froggle" }).to redirect_to signin_url
      end
    end
  end
end