require 'rails_helper'

RSpec.describe PhasesController, :type => :controller do
  
  let(:user)  { FactoryGirl.create(:user, :with_phase, :with_second_phase) }
  let(:user2) { FactoryGirl.create(:user, :with_phase) }
  let(:user3) { FactoryGirl.create(:user) }
  let(:phase) { FactoryGirl.build(:phase) }
  
  context 'when user is not signed in' do

    describe 'GET index' do

      it 'redirects to root_url' do
        get :index, user_id: user.id
        expect(response).to redirect_to root_url
      end
    end

    describe 'new action' do

      it 'redirects to root_url' do
        get :new, user_id: user.id
        expect(response).to redirect_to root_url
      end
    end

    describe 'create action' do

      it 'redirects to root_url' do
        post :create, user_id: user.id
      end
    end

    describe 'edit action' do

      it 'redirects to root_url' do
        phase = user2.phases.first
        get :edit, user_id: user2.id, id: phase.id 
        expect(response).to redirect_to root_url
      end
    end

    describe 'update action' do

      it 'redirects to root_url' do
        phase = user2.phases.first
        patch :edit, user_id: user2.id, id: phase.id 
        expect(response).to redirect_to root_url
      end
    end

    describe 'destroy action' do

      it 'redirects to root_url' do
        phase = user.phases.first
        delete :destroy,  user_id: user.id, id: phase.id
        expect(response).to redirect_to root_url
      end
    end
  end

  context 'when user is signed in' do

    before(:each) { sign_in user, no_capybara: true }
    
    describe 'GET index' do
      
      before(:each) do
        get :index, user_id: user.id 
      end

      it 'returns an array of the right size for the phases' do
        expect(assigns(:phases).size).to eq(user.phases.count)
      end

      it 'contains the phases for the user' do
        user_phases = user.phases.all
        user_phases.collect{ |x| expect(assigns(:phases)).to include(x) }
      end

      it 'does not contain phases for another user' do
        user_phases = user2.phases.all
        user_phases.collect{ |x| expect(assigns(:phases)).not_to include(x) }
      end

      it 'returns an array of the right size for the weeks' do
        expect(assigns(:phase_weeks).size).to eq(user.phases.count)
      end

      it 'returns an array of the right size for the splits' do
        expect(assigns(:phase_splits).size).to eq(user.phases.count)
      end
    end

    describe 'new action' do
      before(:each) do
        get :new, user_id: user.id
      end

      it 'renders the phases/new template' do
        expect(response).to render_template('phases/new')
      end

      it 'responds with status 200' do
        expect(response).to have_http_status(200)
      end
    end

    describe 'create action' do
     
      context 'with invalid information' do 
        before(:each) do
          post :create, user_id: user.id, phase: { user_id: user.id, start_date: "2014-08-01 00:00:00.000", target_date: "2014-03-01 00:00:00.000" }
        end
        
        it 'renders the phases/new template' do
          expect(response).to render_template('phases/new')
        end
      end

      context 'with valid information' do 
        let!(:phase_count) { Phase.count }

        before(:each) do
          post :create, user_id: user.id, phase: { user_id: user.id, start_date: "2013-01-01 00:00:00.000", target_date: "2013-03-01 00:00:00.000"}
        end
        
        it 'increases the Phase.count by 1' do
          expect(Phase.count).to eq(phase_count + 1)
        end
      end
    end

    describe 'edit action' do 
     
      it 'renders the phases/edit template' do
        get :edit, user_id: user.id, id: user.phases.first.id
        expect(response).to render_template('phases/edit')
      end
    end

    describe 'update action' do
      
      context 'with correct parameters' do

        before { patch :update, user_id: user.id, id: user.phases.first.id, phase: { start_date: "2012-01-02 00:00:00.000", 
                  target_date: "2012-03-01 00:00:00.000"  } }

        it 'updates the phase' do
          expect(user.phases.first.start_date).to eq("2012-01-02 00:00:00.000")
        end
      end

      context 'with incorrect parameters' do
        let!(:orig_start_date)  { user.phases.first.start_date }

        before(:each) do
          patch :update, user_id: user.id, id: user.phases.first.id, phase: { start_date: "2014-01-02 00:00:00.000", 
                  target_date: "2012-03-01 00:00:00.000"  } 
        end

        it 'renders the phases/edit template' do
          expect(response).to render_template('phases/edit')
        end
          
        it 'does not alter the phase' do
          expect(user.phases.first.start_date).to eq(orig_start_date)
        end
      end
    end

    describe 'destroy action' do
      let!(:phases_count) { user.phases.count }
      let!(:all_phase_count) { Phase.count }

      context 'when phase exists' do
        
        it 'deletes the phase' do
          delete :destroy, user_id: user.id, id: user.phases.first.id
          expect(user.phases.count).to eq(phases_count - 1)
        end
      end

      context 'when phase does not exist' do

        it 'does not change the phases count' do
          expect(phases_count).to eq(Phase.count)
        end
      end
    end
  end

  context 'when a user is signed in but has no phases' do
    before(:each) do
      sign_in user3, no_capybara: true
      get :index, user_id: user3.id
    end

    it 'returns an array of size 0 for the phases' do
      expect(assigns(:phases).size).to eq(0)
    end
  end
end
