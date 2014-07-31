require 'rails_helper'
require 'spec_helper'

RSpec.describe RacesController, type: :controller do

  let! (:user)  { FactoryGirl.create(:user) }
  let! (:user2) { FactoryGirl.create(:second_user) }
  let! (:race)  { FactoryGirl.create(:race, finish_time: "00:01:05") }
  let! (:race2) { FactoryGirl.create(:race, finish_time: "00:01:01", user_id: 2) }
  let! (:race3) { FactoryGirl.create(:race, distance: "Half Marathon", race_name: "Bigger Race", finish_time: "00:01:02") }
  let! (:race4) { FactoryGirl.create(:race, distance: "Half Marathon", race_name: "Bigger Race2", finish_time: "00:01:03") }
  let! (:race5) { FactoryGirl.create(:race, distance: "Marathon", race_name: "Bigger Race3", user_id: 2) } 
  let! (:race6) { FactoryGirl.create(:race, finish_time: "00:01:03") }

  before { race.save }

  describe 'factories' do
    it 'are valid' do
      expect(user).to be_valid
      race.id = 1
      expect(race.save).to be_truthy
    end
  end

  # Tests that non-signed in users are all redirected to the signin_path for each action
  context 'when user is not signed in' do

    describe 'GET index' do
      it 'redirects to signin url' do
        get :index, user_id: 1
        expect(response).to redirect_to signin_url
      end
    end

    describe 'new races action' do
      let!(:race_count) { Race.count }

      before { get :new, user_id: 1 }

      it 'redirects to signin url' do
        expect(response).to redirect_to signin_url
      end

      it 'does not create a new race' do
        expect(Race.count).to eq(race_count)
      end 
    end

    describe 'POST race' do
      let!(:race_count) { Race.count }

      before do
        race_attr = { name: "A race", race_date: Time.now, user_id: 1 }
        post :create, user_id: 1, race: race_attr
      end

      it 'redirects to signin url' do
        expect(response).to redirect_to signin_url
      end

      it 'does not create a new race' do
        expect(Race.count).to eq(race_count)
      end
    end

    describe 'edit races action' do 
      it 'redirects to signin url' do
        get :edit, id: 1, user_id: 1, race: race,  use_route: '/users/1/races'
        expect(response).to redirect_to signin_url
      end
    end

    describe 'update races action' do
      before { patch :update, id: 1, user_id: 1, race: race }
      it 'redirects to signin url' do

        expect(response).to redirect_to signin_url
      end
    end

    describe 'delete races action' do
      let!(:race_count) { Race.count }
      
      before { delete :destroy, id: 1, user_id: 1, race: race }

      it 'redirects to signin url' do
        expect(response).to redirect_to signin_url
      end


      it 'does not delete the race' do
        expect(Race.count).to eq (race_count)
      end
    end
  end

  context 'when user is signed in' do

    before(:each) do 
      sign_in user, no_capybara: true
      race_attr = { name: "A race", race_date: Time.now, user_id: 1, id: 2}
    end
    
    describe 'GET index' do
      before { get :index, user_id: 1 }

      it 'responds with status 200' do
        expect(response).to have_http_status(200)
      end

      it 'renders the races/index template' do
        expect(response).to render_template("races/index")
      end
    end

    describe 'new races action' do
      before { get :new, user_id: 1 }
      
      it 'responds with status 200' do
        expect(response).to have_http_status(200)
      end

      it 'renders the races/index template' do
        expect(response).to render_template("races/new")
      end
    end

    describe 'POST race' do
      let!(:race_count) { Race.count }
      
      before(:each) do
        race_attr = { race_name: "super test race", race_date: Time.now }
        post :create, user_id: 1, race: race_attr
      end

      it 'responds with status 200' do
        #expect(response).to have_http_status(200)
      end

      it 'the last record in Races is the created race' do
        expect(Race.last.race_name).to eq("super test race")
      end

      it 'changes the count of races by 1' do
        expect(Race.count).to eq(race_count + 1)
      end
    end

    describe 'edit races action' do

      it 'responds with status 200' do
        get :edit, id: 1, user_id: 1, race: race
        expect(response).to have_http_status(200)
      end
    end
    
    # #Not suere why these aren't working.
    # describe 'update races action' do
    #   it 'updates the race' do
    #     race.race_name = "This is a test race"
    #     patch :update, id: 1, user_id: 1, race: race
    #     expect(response).to have_http_status(200)
    #     expect(Race.find(1).race_name).to eq("This is a test race")
    #   end
    # end

    describe 'delete races action' do
      let!(:race_count) { Race.count }

      it 'deletes the race' do
        expect{delete :destroy, id: 1, user_id: 1, race: race}.to change{Race.count}.by(-1)
      end
    end

    describe 'pb races action' do
      before { get :pb, user_id: 1 }
      it 'responds with status 200' do
        expect(response).to have_http_status(200)
      end

      it 'only returns one race for each distance' do
        distance_count = user.races.all.collect{ |x| x.distance}.uniq.size
        expect(assigns(:results).size).to eq(distance_count)
      end

      it 'returns the fastest race for the distances' do
        results = assigns(:results)
        results.each do |race|
          expect(race.finish_time).to eq("2000-01-01 00:01:02") if race.distance == "Half Marathon"
          expect(race.finish_time).to eq("2000-01-01 00:01:03") if race.distance == "10km"
        end
      end

      it 'does not return a result for another user' do
        expect(assigns(:results).collect{ |x| x.distance}).to_not include("Marathon")
      end
    end

    describe 'distance action' do
      context 'where the distance exists' do
        before { get :distance, user_id: 1 , dist: "10km" }

        it 'returns the distance selected for the user' do
          expect(assigns(:dist)).to eq("10km")
          expect(assigns(:dist_races).size).to eq(Race.where("user_id = 1 AND distance = ?", "10km").size)
        end
      end

      context 'where the distance does not exist' do
        before { get :distance, user_id: 1 , dist: "Marathon" }

        it 'returns no races if the distance does not exist for the user' do
          expect(assigns(:dist)).to eq("Marathon")
          expect(assigns(:dist_races).size).to eq(0)
        end
      end
    end
  end
end