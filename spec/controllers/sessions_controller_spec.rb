require 'rails_helper'
require 'spec_helper'


RSpec.describe SessionsController, type: :controller do

  let!(:user)  { FactoryGirl.create(:user) }
  
  describe 'new session action' do
  
    context 'when user is not signed in' do

      it 'renders the sessions/new template' do
        expect(get :new, use_route: 'signin').to render_template('sessions/new')
      end
    end

    context 'when user is signed in' do

      it 'redirects to root_url' do
        sign_in user, no_capybara: true
        expect(get :new).to redirect_to root_url
      end
    end
  end

  describe 'create session action' do

    context 'when user is not signed in' do

      context 'with valid information' do
        before(:each) { post :create,   session: { email: User.first.email, password: "froggle" } } 

        it 'renders the users/show template' do
          expect(response).to redirect_to user_url(user.id)
        end 

        it 'signs in the user' do
          expect(subject.current_user).to_not eq(nil)
        end
      end

      context 'with invalid information' do
        before(:each) { post :create,   session: { email: User.first.email, password: "incorrect password" } } 

        it 'renders the session/new template' do
          expect(response).to render_template('sessions/new')
        end

        it 'does not sign in the user' do
          expect(subject.current_user).to eq(nil)
        end
      end
    end
  end

  describe 'destroy session action' do
   
    context 'when the user is signed in' do
      before(:each) do 
        sign_in user, no_capybara: true 
        delete :destroy
      end

      it 'destroys the session' do
        expect(subject.current_user).to eq(nil)
      end

      it 'redirects to the root url' do
        expect(response).to redirect_to root_url
      end
    end

    context 'when the user is not signed in' do

      it 'redirects to the root url' do
        expect(delete :destroy).to redirect_to root_url
      end
    end
  end
end